//
//  TextToSpeechService.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation
import AVFoundation

class TextToSpeechService {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String, language: String = "en-US", rate: Float = 0.5, pitchMultiplier: Float = 1.0, volume: Float = 1.0) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        utterance.pitchMultiplier = pitchMultiplier
        utterance.volume = volume
        
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func pauseSpeaking() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    func resumeSpeaking() {
        synthesizer.continueSpeaking()
    }
    
    func isSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }
}
