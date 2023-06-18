//
//  DataManager.swift
//  ChadGPT
//
//  Created by Elisa Zhang on 11.06.23.
//

import Foundation
import CoreData
import os

class DataManager: ObservableObject {
    
    public static let shared = DataManager()
    
    /// All access needs to happen via the `.shared` instance
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatData")
        container.loadPersistentStores { _, error in
            if let error = error {
                log.error("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveChatHistory(role: String, message: String) {
        let newChatHistory = ChatHistory(context: viewContext)
        newChatHistory.role = role
        newChatHistory.message = message
        
        do {
            try viewContext.save()
            log.info("Sucessfully saved chat history: role=\(role), message=\(message)")
        } catch {
            log.error("Failed to add chat history: \(error)")
        }
    }
    
    public func clearChatHistory() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: ChatHistory.fetchRequest())
        
        do {
            try viewContext.execute(deleteRequest)
            log.info("Chat history cleared successfully")
        } catch {
            log.error("Failed to clear chat history: \(error)")
        }
    }
    
    func loadChatHistory() -> [ChatHistory] {
        let request : NSFetchRequest<ChatHistory> = ChatHistory.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            log.error("Loading Chat History failed: \(error)")
        }
        
        return []
    }
    
    func savePickUpLine(line: String) {
        let newPickUpLine = PickupLine(context: viewContext)
        newPickUpLine.content = line
        
        do {
            try viewContext.save()
            log.info("Pickup line \(line) saved successfully")
        } catch {
            log.error("Failed to save pickup line: \(error)")
        }
    }
    
    func loadPickUpLines() -> [PickupLine] {
        let request : NSFetchRequest<PickupLine> = PickupLine.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            log.error("Failed to load pickuplines: \(error)")
        }
        return []
    }
    
    func deleteItem(withContent content: String) {
        let fetchRequest: NSFetchRequest<PickupLine> = PickupLine.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "content == %@", content)
        fetchRequest.fetchLimit = 1
        
        do {
            let items = try viewContext.fetch(fetchRequest)
            
            for item in items {
                viewContext.delete(item)
                log.info("deleting line: \(String(describing: item.content))")
            }
            
            try viewContext.save()
        } catch {
            log.error("Error deleting item: \(error)")
        }
    }
}
