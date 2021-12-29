//
//  Chata_data_Messaage.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
import CoreData
import UIKit
extension ChatDataManager {
    
    func saveMessages(_ messages_list : [MessagesList]) {
        guard let username =  UserDefaults.standard.getUserData()?.user.username else {
            print("🚨 Error the username")
            return
        }
        let context = PersistenceController.shared.container.viewContext
            messages_list.forEach({msg  in
                let chatmessage : ChatMessages =  ChatMessages(context: context)
                let (status, _ ) =   checkExistMessage(message_id: msg.id)
                if !status {
                    chatmessage.id = Int64(msg.id)
                    chatmessage.uuid = (msg.uuid != nil) ? UUID(uuidString: msg.uuid!) : UUID()
                    chatmessage.type =  Int16(msg.type)
                    chatmessage.content =  msg.content.rawValue
                    chatmessage.session_id = Int64(msg.sessionID)
                    chatmessage.message = msg.message
                    chatmessage.user_name = username
                    chatmessage.read_at =  ((msg.readAt) != nil)
                    chatmessage.read_at_date = msg.readAt?.date
                    chatmessage.send_date =  msg.sendAt.date
                    chatmessage.user = msg.user
                    do {
                        try context.save()
                        
                    } catch let error as NSError {
                        
                        print("\(TAG) error the save user \(error)")
                        
                        
                    }
                    
                }
        })
        
    }
    
    func checkExistMessage( message_id : Int) -> (Bool, [ChatMessages]?) {
        let context = PersistenceController.shared.container.viewContext
        var result = [ChatMessages] ()
        let fetchrequest : NSFetchRequest<ChatMessages> = ChatMessages.fetchRequest()
        
        fetchrequest.predicate = NSPredicate(format: "id == %i", message_id)
        do {
            result = try context.fetch(fetchrequest)
            if result.count > 0 {
                return (true, result)
            }
            return (false, nil)
        } catch let error as NSError {
            print("\(TAG) \(error)")
            return (false,nil)
        }
        
    }
  
    func updateAllReadedMessage(session_id : Int64) {
        let context = PersistenceController.shared.container.viewContext
        var resultado = [NSManagedObject] ()
        let fetchrequest : NSFetchRequest<ChatMessages> = ChatMessages.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "session_id == %i", session_id)
        do {
            resultado = try context.fetch(fetchrequest)
            let resultadata = resultado as! [ChatMessages]
            
            if resultadata.count > 0 {
                let chatMessage =  resultado[0] as! ChatMessages
                chatMessage.read_at = true
                
                do {
                    print("\(TAG) update ready from updateAllReaded")
                    try context.save()
                    
                } catch {
                    print("Error: search in driverscheduletb")
                }
                
            }
        } catch let error as NSError {
            print("\(TAG) update ChatUsers \(error)")
        }
    }
    
    
    
    
    func updateReadedMessage(message_id : Int64) {
        let context = PersistenceController.shared.container.viewContext
        var resultado = [NSManagedObject] ()
        let fetchrequest : NSFetchRequest<ChatMessages> = ChatMessages.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "id == %@", message_id)
        do {
            resultado = try context.fetch(fetchrequest)
            let resultadata = resultado as! [ChatMessages]
            
            if resultadata.count > 0 {
                let chatMessage =  resultado[0] as! ChatMessages
                chatMessage.read_at = true
                
                do {
                    try context.save()
                    
                } catch {
                    print("Error: search in driverscheduletb")
                }
                
            }
        } catch let error as NSError {
            print("\(TAG) update ChatUsers \(error)")
        }
    }
    
    func updateReadedMessageByUIDD(uuid : UUID) {
        let context = PersistenceController.shared.container.viewContext
        var resultado = [NSManagedObject] ()
        let fetchrequest : NSFetchRequest<ChatMessages> = ChatMessages.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        do {
            resultado = try context.fetch(fetchrequest)
            let resultadata = resultado as! [ChatMessages]
            
            if resultadata.count > 0 {
                let chatMessage =  resultado[0] as! ChatMessages
                chatMessage.read_at = true
                
                do {
                    try context.save()
                    
                } catch {
                    print("Error: search in driverscheduletb")
                }
                
            }
        } catch let error as NSError {
            print("\(TAG) update ChatUsers \(error)")
        }
    }
    
    func getMessages(session_id : Int64) -> (Bool, [ChatMessages]?) {
        
        let context = PersistenceController.shared.container.viewContext
        
        var result = [ChatMessages] ()
        
        let fetchrequest : NSFetchRequest<ChatMessages> = ChatMessages.fetchRequest()
        
        
        
        fetchrequest.predicate = NSPredicate(format: "session_id == %i", session_id)
        
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchrequest.sortDescriptors = [sort]
        
            do {
            result = try context.fetch(fetchrequest)
            if result.count > 0 {
                return (true, result)
            }
            return (false, nil)
        } catch let error as NSError {
            print("\(TAG) \(error)")
            return (false,nil)
        }
        
    }
    
    func insertNewMessage(chatMessageR : ChatMessages) {
       
        let context = PersistenceController.shared.container.viewContext
        
        let chatmessage : ChatMessages =  ChatMessages(context: context)
        
        chatmessage.id = chatMessageR.id
        chatmessage.uuid = chatMessageR.uuid
        chatmessage.type =  chatMessageR.type
        chatmessage.content =  chatmessage.content
        chatmessage.session_id = chatmessage.session_id
        chatmessage.message = chatmessage.message
        chatmessage.user_name = chatmessage.user
        chatmessage.read_at =  chatmessage.read_at
        chatmessage.read_at_date = nil
        chatmessage.send_date =  chatmessage.send_date
        chatmessage.user = chatmessage.user
//
            do {
                try context.save()
                
            } catch let error as NSError {
                
                print("\(TAG) error the save user \(error)")
                
                
            }
            
        
       
    }
    
    
    func insertMessage(chat : Chat) {
        guard let username =  UserDefaults.standard.getUserData()?.user.username else {
            print("🚨 Error the username")
            return
        }
        let context = PersistenceController.shared.container.viewContext
        
        let chatmessage : ChatMessages =  ChatMessages(context: context)
        guard let lastmessage = chat.messages.last else {
            return
        }
            chatmessage.id = 0
            chatmessage.uuid = chat.messages.last?.id
            chatmessage.type =  (chat.messages.last?.type == MessageType.send) ? 0 : 1
            chatmessage.content =  lastmessage.content_type.rawValue
            chatmessage.session_id = Int64(chat.session_id)
            chatmessage.message = lastmessage.text
            chatmessage.user_name = username
            chatmessage.read_at =  false
            chatmessage.read_at_date = nil
            chatmessage.send_date =  lastmessage.date.description
            chatmessage.user = username
            do {
                try context.save()
                
            } catch let error as NSError {
                
                print("\(TAG) error the save user \(error)")
                
                
            }
            
        
       
    }
    
}
