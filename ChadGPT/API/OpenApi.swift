//
//  API.swift
//  ChadGPT
//
//  Created by Felix Schindler on 18.06.23.
//

import Foundation
import os

// MARK: - API responses
struct ApiResponse: Codable {
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

struct Message: Codable, Equatable, Hashable {
    var role: String    // "user", "system" ; Need to be var so you can compare using `==` it when using @Binding
    let content: String
    
    
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.role == rhs.role && lhs.content == rhs.content
    }
}

struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int
}

class OpenApi {
    // TODO: Add generics
    public static func post<T: Codable>(type: T.Type, url: URL, authToken: String? = nil, body: Dictionary<String, Any>) async -> T? {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            log.debug("POST \(url.absoluteString)")
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            log.error("API request failed \(error)")
            return nil
        }
    }
}
