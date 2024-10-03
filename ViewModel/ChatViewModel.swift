//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Santhosh on 30/09/24.
//

import Foundation
import CoreData

class ChatViewModel {
    private let context = CoreDataStack.shared.context
    
    func fetchMessages() -> [MessageEntity] {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch failed")
            return []
        }
    }
}
