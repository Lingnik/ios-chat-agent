//
//  GPT3Service.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation
import Alamofire

class GPT3Service {
    private let apiKey = "<YOUR_API_KEY>"
    private let apiURL = "https://api.openai.com/v1/chat/completions"

    func generateResponse(messages: [[String: Any]], completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages
        ]

        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonResponse = value as? [String: Any],
                       let choices = jsonResponse["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        completion(.success(content))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid API response"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
