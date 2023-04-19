//
//  Transcription.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation

struct Transcription {
    /// A String containing the transcribed text.
    let text: String
    /// A Double representing the confidence score for the transcription, ranging from 0 to 1.
    let confidence: Double
    /// A TimeInterval representing the start time of the transcribed audio segment in seconds.
    let startTime: TimeInterval
    /// A TimeInterval representing the end time of the transcribed audio segment in seconds.
    let endTime: TimeInterval
    
    /// Initializes a new Transcription with the specified text, confidence, start time, and end time.
    ///
    /// - Parameters:
    ///   - text: The transcribed text.
    ///   - confidence: The confidence score for the transcription, ranging from 0 to 1.
    ///   - startTime: The start time of the transcribed audio segment in seconds.
    ///   - endTime: The end time of the transcribed audio segment in seconds.
    init(text: String, confidence: Double, startTime: TimeInterval, endTime: TimeInterval) {
        self.text = text
        self.confidence = confidence
        self.startTime = startTime
        self.endTime = endTime
    }
}
