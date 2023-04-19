//
//  AudioRecorder.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//
//
// The AudioRecorder class also conforms to the AVAudioRecorderDelegate protocol, implementing the audioRecorderDidFinishRecording(_:successfully:) method to handle the case when recording finishes or is interrupted.
// 
// Note that you might need to request permission to access the microphone before using this class. You can do this by calling AVAudioSession.sharedInstance().requestRecordPermission(_:) and checking the user's response.

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    
    /// Starts audio recording and saves the recorded file at the specified URL.
    ///
    /// - Parameter fileURL: The URL where the recorded audio file will be saved.
    func startRecording(to fileURL: URL) {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            isRecording = true
        } catch {
            print("Error setting up audio recorder: \(error.localizedDescription)")
        }
    }
    
    /// Stops audio recording.
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording failed or was interrupted.")
        }
    }
}
