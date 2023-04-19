//
//  WhisperService.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation

class WhisperService {
    private let apiKey: String
    private let apiUrl = "https://api.openai.com/v1/audio/transcriptions"

    /// Initializes a new WhisperService with the specified API key.
    ///
    /// - Parameter apiKey: The API key for accessing OpenAI's Whisper ASR API.
    init(apiKey: String) {
        self.apiKey = apiKey
    }

    /// Transcribes the audio file using OpenAI's Whisper ASR API.
    ///
    /// - Parameters:
    ///   - audioData: The audio data to transcribe.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func transcribe(_ audioData: Data, completionHandler: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let disposition = "Content-Disposition: form-data; name=\"file\"; filename=\"audio.wav\"\r\n"
        let contentType = "Content-Type: audio/wav\r\n\r\n"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append(disposition.data(using: .utf8)!)
        body.append(contentType.data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let text = json["text"] as! String
                    completionHandler(.success(text))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
}
