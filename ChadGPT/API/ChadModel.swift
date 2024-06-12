//
//  ChadModel.swift
//  ChadGPT
//
//  Created by Elisa Zhang on 17.05.23.
//

import Foundation
import os


let log = Logger()

// MARK: - API Client
class ChadModel {
    static let shared = ChadModel()
    
    private let apiKey = "some key"
    private let baseUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
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
                DataManager.shared.clearChatHistory()
            } else {
                log.error("Failed to persist ChadSettings (`ChadModel.settings`)")
            }
        }
    }
    
    private init() {
    }
    
    /// Generates pick-up line based on user input
    ///
    /// - Parameters:
    ///   - userMsg: A new prompt / message by the user
    ///
    /// - Returns: The decoded API response
    func generatePickupLines(_ userMessage: String) async -> [String] {
        let systemMessage: String = ChadStyle.flirty.rawValue
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": systemMessage],
                ["role": "user", "content": userMessage]
            ]
        ]
        
        if let res = await OpenApi.post(type: ApiResponse.self, url: self.baseUrl, authToken: apiKey, body: parameters) {
            return res.choices.map { $0.message.content }
        }

        return []
    }
    
    /// Sends chat messages to API
    ///
    /// - Parameters:
    ///     - messages: all messages within the chat
    ///     - systemMessage: defines message content
    ///
    ///  - Returns: Messages from API Response
    ///
    func sendMessage(_ messages: [Message], systemMessage: String? = nil) async -> [Message] {
        var temp = [[String: String]]()
        
        for message in messages {
            let messageDict = ["role": message.role, "content": message.content]
            temp.append(messageDict)
        }
        
        var ourSysMsg = ""
        if (systemMessage == nil) {
            ourSysMsg = "\(self.settings.style.rawValue)\n\n" + "Pretend to be \(self.settings.name) and NEVER get out of your role! Speak like they would do and do not show that you might not be \(self.settings.name)."
        } else {
            ourSysMsg = systemMessage!
        }
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": ourSysMsg]
            ] + temp
        ]
        
        if let res = await OpenApi.post(type: ApiResponse.self, url: self.baseUrl, authToken: apiKey, body: parameters) {
            return res.choices.map { Message(role: "system", content: $0.message.content) }
        }
        
        return []
    }
}
