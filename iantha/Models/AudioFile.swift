//
//  AudioFile.swift
//  iantha
//
//  Created by Taylor Meek on 4/3/23.
//

import Foundation

struct AudioFile {
    /// A URL pointing to the location of the audio file on the device.
    let url: URL
    
    /// A Date representing when the audio file was created.
    let createdAt: Date
    
    /// A computed property that returns the file name of the audio file.
    var fileName: String {
        return url.lastPathComponent
    }
    
    /// The duration of the audio file in seconds.
    var duration: TimeInterval {
        // Calculate the duration of the audio file using AVAudioPlayer or another method
        // TODO: Calculate the duration of the audio file in seconds. You will need to implement the appropriate method to calculate the duration using AVAudioPlayer or another method.
        return 0.0 // Replace this with the actual duration calculation result

    }
    
    /// Initializes a new AudioFile with the specified URL and creation date.
    ///
    /// - Parameters:
    ///   - url: The URL of the audio file.
    ///   - createdAt: The date the audio file was created.
    init(url: URL, createdAt: Date) {
        self.url = url
        self.createdAt = createdAt
    }
}
