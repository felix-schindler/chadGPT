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

// MARK: - API responses
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

// MARK: - API Client
class ChadModel {
    public static let shared = ChadModel()
    
    private let ApiKey = "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"
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    public var settings: ChadSettings {
        get {
            if let data = UserDefaults.standard.data(forKey: "chad_settings") {
                if let decoded = try? JSONDecoder().decode(ChadSettings.self, from: data) {
                    return decoded
                }
            }
            return ChadSettings(style: .cute, name: "Cardi B")
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                // Persist with `UserDefaults`
                UserDefaults.standard.set(encoded, forKey: "chad_settings")
                // TODO: Clear chat history
                // DataManager.shared.clearChatHistory()
            } else {
                print("[ERROR] Failed to persist ChadSettings (`ChadModel.settings`)")
            }
        }
    }
    
    private init() {
    }
    
    /// Calculates the sum of two integers.
    ///
    /// - Parameters:
    ///   - userMsg: A new prompt / message by the user
    ///
    /// - Returns: The decoded API response
    func makeAPIRequest(_ userMsg: String, systemMessage: String? = nil) async throws -> API_RES {
        guard let requestURL = URL(string: "\(baseURL)") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(ApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var ourSysMsg = ""
        if (systemMessage == nil) {
            ourSysMsg = "\(self.settings.style.rawValue)\n\n" + "Also, always speak like \(self.settings.name) and NEVER get out of your role!"
        } else {
            ourSysMsg = systemMessage!
        }
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": ourSysMsg],
                ["role": "user", "content": userMsg]
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


// MARK: - Settings
enum ChadStyle: String, Codable, CaseIterable {
    case cute = "1. Speak in uwu text.\n2. Always talk extremly cutely\n3. Replace all r's with w's to sound even cuter.\n4. End every sentence with a cute action.",
         sophisticated = "1. Speak extemely sophisticated\n2. Be mentually mature\n3. End every sentence with this Emoji: '🧐'",
         tsundere = "1. Speak like a tsundere",
         flirty = "1. Help the user get a partner\n2. You may only answer with a single pickup line\n3. You may use puns"
}

struct ChadSettings: Codable {
    let style: ChadStyle
    let name: String
}
