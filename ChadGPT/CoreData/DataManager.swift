//
//  DataManager.swift
//  ChadGPT
//
//  Created by Elisa Zhang on 11.06.23.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    
    public static let shared = DataManager()
    
    /// All access needs to happen via the `.shared` instance
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveChatHistory(role: String, message: String) {
        print("Saving chat history: role=\(role), message=\(message)")
        let newChatHistory = ChatHistory(context: viewContext)
        newChatHistory.role = role
        newChatHistory.message = message
        
        do {
            try viewContext.save()
            print("Added new message successfully")
        } catch {
            print("Failed to add chat history: \(error)")
        }
    }
    
    public func clearChatHistory() {
        print("Clearing chat history")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: ChatHistory.fetchRequest())
        
        do {
            try viewContext.execute(deleteRequest)
            print("Chat history cleared successfully")
        } catch {
            print("Failed to clear chat history: \(error)")
        }
    }
    
    func loadChatHistory() -> [ChatHistory] {
        let request : NSFetchRequest<ChatHistory> = ChatHistory.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            print("Loading Chat History failed: \(error)")
        }
        
        return []
    }
    
    func savePickUpLine(line: String) {
        print("Saving pickup line: \(line)")
        let newPickUpLine = PickupLine(context: viewContext)
        newPickUpLine.content = line
        
        do {
            try viewContext.save()
            print("Pickup line saved")
        } catch {
            print("Failed to save pickup line: \(error)")
        }
    }
    
    func loadPickUpLines() -> [PickupLine] {
        let request : NSFetchRequest<PickupLine> = PickupLine.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            print("Failed to load pickuplines: \(error)")
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
                print("deleting line: \(String(describing: item.content))")
            }
            
            try viewContext.save()
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
