//
//  ChadModel.swift
//  ChadGPT
//
//  Created by Elisa Zhang on 17.05.23.
//

import Foundation

class ChadModel {
    let ApiKey = "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"
    let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    
    func makeAPIRequest(prompt: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let requestURL = URL(string: "\(baseURL)") else {
            completionHandler(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(ApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are your friend's wingman. You help your friend come up with pick-up lines. You only answer with pick-up lines."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                completionHandler(.failure(NSError(domain: "Invalid HTTP status code: \(httpResponse.statusCode)", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = responseJSON as? [String: Any], let choices = responseDict["choices"] as? [[String: Any]], let completion = choices.first?["message"] as? [String: Any], let content = completion["content"] as? String {
                    completionHandler(.success(content))
                } else {
                    completionHandler(.failure(NSError(domain: "Invalid response format", code: 0, userInfo: nil)))
                }
            } catch {
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
