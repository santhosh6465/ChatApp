//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Santhosh on 30/09/24.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages: [MessageEntity] = []
    let coreDataStack = CoreDataStack.shared


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
        fetchMessages() // Fetch messages from Core Data
        loadInitialMessages() // Load initial static messages
        
        messageTextField.layer.cornerRadius = 10
        messageTextField.layer.masksToBounds = true
        messageTextField.layer.borderColor = UIColor.lightGray.cgColor
        messageTextField.layer.borderWidth = 1
        
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        tableView.register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
    }

    private func fetchMessages() {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        do {
            messages = try coreDataStack.context.fetch(fetchRequest)
            tableView.reloadData()
            scrollToBottom() // Scroll to bottom after fetching messages
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    private func clearAllChats() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MessageEntity.fetchRequest() // Use NSFetchRequestResult
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coreDataStack.context.execute(deleteRequest)
            fetchMessages() // Refresh the messages after deletion
        } catch {
            print("Error clearing chats: \(error)")
        }
    }
    
    //  Load initial static messages
    private func loadInitialMessages() {
        // Check if there are no messages
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        do {
            let count = try coreDataStack.context.count(for: fetchRequest)
            if count == 0 { // Only add static messages if there are no existing messages
                let staticMessage = MessageEntity(context: coreDataStack.context)
                staticMessage.text = "Hi! How can I help you today?"
                staticMessage.isIncoming = true // Static message is incoming
                staticMessage.timestamp = Date()
                coreDataStack.saveContext()
            }
        } catch {
            print("Failed to fetch messages count: \(error)")
        }
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        let newMessage = MessageEntity(context: coreDataStack.context)
        newMessage.text = text
        newMessage.isIncoming = false // Assuming outgoing message
        newMessage.timestamp = Date()
        coreDataStack.saveContext()
        messageTextField.text = ""
        fetchMessages()
    }
    
    @IBAction func clearChat(_ sender: UIButton) {
        let alert = UIAlertController(title: "Clear Chats", message: "Are you sure you want to clear all chats?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            self.clearAllChats()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.isIncoming {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageCell
            cell.selectionStyle = .none
            cell.messageLabel.text = message.text
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageCell
            cell.messageLabel.text = message.text
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    // Implement delegate methods if needed
}
