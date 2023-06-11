//
//  ChadModel.swift
//  ChadGPT
//
//  Created by Elisa Zhang on 17.05.23.
//

import Foundation

enum Sender: String {
    case system = "system",
         bot = "assistant",
         human = "user"
}

struct API_RES: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
    let finishReason: String
    let index: Int
}

struct Message: Codable {
    var role: String    // "user", "system" ; Need to be var so you can compare using `==` it when using @Binding
    let content: String
}

struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int
}

class ChadModel {
    public static let shared = ChadModel()

    public static let CUTE = "1. Speak in uwu text.\n2. Always talk extremly cutely\n3. Replace all r's with w's to sound even cuter.\n4. End every sentence with a cute action."

    private let ApiKey = "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"
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    private init() {
    }
    
    func makeAPIRequest(systemMessage: String, prompt: String) async throws -> API_RES {
        guard let requestURL = URL(string: "\(baseURL)") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(ApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": systemMessage],
                ["role": "user", "content": prompt]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Invalid HTTP status code: \(httpResponse.statusCode)", code: 0, userInfo: nil)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(API_RES.self, from: data)
        } catch {
            throw error
        }
    }
    
}
