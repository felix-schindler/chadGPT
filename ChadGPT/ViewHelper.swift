//
//  ViewHelper.swift
//  ChadGPT
//
//  Created by Elisa Zhang on 18.06.23.
//

import Foundation

class ViewHelper {
    
    let dataManager = DataManager.shared
    
    func reloadStarredList() -> [String] {
        var starred: [String] = []
        for line in dataManager.loadPickUpLines() {
            starred.append(line.content ?? "")
        }
        return starred
    }
    
    func loadChatHistory() -> [Message] {
        return dataManager.loadChatHistory().map { Message(role: $0.role ?? "", content: $0.message ?? "") }
    }
    
    func generatePickUpLine(userInput : String) async -> [String] {
        var lines: [String] = []
        let newLines = await ChadModel.shared.generatePickupLines(userInput)
        newLines.forEach { lines.insert($0, at: 0) }
        return lines
    }
}
