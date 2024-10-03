//
//  Coremodel.swift
//  ChatApp
//
//  Created by Santhosh on 30/09/24.
//
import Foundation

struct Message {
    let text: String
    let isIncoming: Bool
    let timestamp: Date
    
    // Initialize from parameters
    init(text: String, isIncoming: Bool, timestamp: Date) {
        self.text = text
        self.isIncoming = isIncoming
        self.timestamp = timestamp
    }
    
    // Initialize from a Core Data managed object
    init(entity: MessageEntity) {
        self.text = entity.text ?? ""
        self.isIncoming = entity.isIncoming
        self.timestamp = entity.timestamp ?? Date()
    }
}
