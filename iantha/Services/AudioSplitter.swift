//
//  AudioSplitter.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation
import AVFoundation

class AudioSplitter {
    func splitAudio(url: URL, silenceThreshold: Float, minChunkDuration: TimeInterval, maxChunkDuration: TimeInterval, completion: @escaping ([AVAssetExportSession]) -> Void) {
        let asset = AVAsset(url: url)
        
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "tracks", error: &error)
            
            if status == .loaded {
                let audioTrack = asset.tracks(withMediaType: .audio).first
                
                if let audioTrack = audioTrack {
                    let assetReader: AVAssetReader
                    do {
                        assetReader = try AVAssetReader(asset: asset)
                    } catch {
                        print("Error creating asset reader: \(error.localizedDescription)")
                        return
                    }
                    
                    let assetReaderOutputSettings: [String: Any] = [
                        AVFormatIDKey: Int(kAudioFormatLinearPCM),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 1,
                        AVLinearPCMBitDepthKey: 16,
                        AVLinearPCMIsBigEndianKey: false,
                        AVLinearPCMIsFloatKey: false
                    ]
                    
                    let assetReaderOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: assetReaderOutputSettings)
                    assetReader.add(assetReaderOutput)
                    assetReader.startReading()
                    
                    var samples = [CMSampleBuffer]()
                    
                    while let sampleBuffer = assetReaderOutput.copyNextSampleBuffer() {
                        samples.append(sampleBuffer)
                    }
                    
                    let silenceAnalyzer = SilenceAnalyzer(silenceThreshold: silenceThreshold)
                    let splitTimes = silenceAnalyzer.detectSilences(samples: samples, minChunkDuration: minChunkDuration, maxChunkDuration: maxChunkDuration)
                    
                    self.exportAudioChunks(asset: asset, splitTimes: splitTimes, completion: completion)
                }
            } else {
                print("Error loading asset: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func exportAudioChunks(asset: AVAsset, splitTimes: [CMTime], completion: @escaping ([AVAssetExportSession]) -> Void) {
        var exportSessions = [AVAssetExportSession]()
        let assetDuration = asset.duration
        let exportFileType = AVFileType.m4a
        
        for i in 0..<splitTimes.count {
            let startTime = splitTimes[i]
            let endTime: CMTime
            if i < splitTimes.count - 1 {
                endTime = splitTimes[i + 1]
            } else {
                endTime = assetDuration
            }
            
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
                exportSession.outputFileType = exportFileType
                exportSession.timeRange = timeRange
                
                let outputURL = generateOutputURL()
                exportSession.outputURL = outputURL
                
                exportSession.exportAsynchronously {
                    if exportSession.status == .completed {
                        print("Exported successfully: \(outputURL)")
                    } else {
                        print("Error exporting: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                    }
                }
                
                exportSessions.append(exportSession)
            }
        }
        completion(exportSessions)
    }
    
    private func generateOutputURL() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: Date())
        let fileName = "audio_chunk_\(dateString).m4a"
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(fileName)
    }
    
}

class SilenceAnalyzer {
    let silenceThreshold: Float
    
    init(silenceThreshold: Float) {
        self.silenceThreshold = silenceThreshold
    }
    
    func detectSilences(samples: [CMSampleBuffer], minChunkDuration: TimeInterval, maxChunkDuration: TimeInterval) -> [CMTime] {
        var splitTimes = [CMTime]()
        var currentSilenceDuration: TimeInterval = 0
        var currentChunkDuration: TimeInterval = 0
        
        for sampleBuffer in samples {
            let sampleDuration = sampleBuffer.duration.seconds
            currentChunkDuration += sampleDuration
            
            if isSilent(sampleBuffer) {
                currentSilenceDuration += sampleDuration
            } else {
                currentSilenceDuration = 0
            }
            
            if currentSilenceDuration >= minChunkDuration && currentChunkDuration >= maxChunkDuration {
                splitTimes.append(sampleBuffer.presentationTimeStamp - CMTime(seconds: currentSilenceDuration, preferredTimescale: sampleBuffer.duration.timescale))
                currentChunkDuration = 0
            }
        }
        
        return splitTimes
    }
    
    private func isSilent(_ sampleBuffer: CMSampleBuffer) -> Bool {
        if let audioBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
            let audioBufferData = UnsafeMutablePointer<Int16>.allocate(capacity: CMBlockBufferGetDataLength(audioBuffer))
            CMBlockBufferCopyDataBytes(audioBuffer, atOffset: 0, dataLength: CMBlockBufferGetDataLength(audioBuffer), destination: audioBufferData)
            
            let audioBufferLength = CMBlockBufferGetDataLength(audioBuffer) / MemoryLayout<Int16>.size
            
            var sum: Float = 0
            for i in 0..<audioBufferLength {
                let sample = Float(audioBufferData[i]) / Float(Int16.max)
                sum += sample * sample
            }
            
            audioBufferData.deallocate()
            
            let rms = sqrtf(sum / Float(audioBufferLength))
            return rms < silenceThreshold
        }
        
        return false
    }
}
