//
//  chat_data.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 11/2/21.
//

import Foundation
import CoreData
import UIKit
import SwiftUI
import simd

class Chata_data {
     
    let TAG : String = "💬 CHAT_DATA"
    
    func getAllUserWithMessageMe(usernameID : String )-> (Bool, [ChatUsers]?) {
        
        let context = PersistenceController.shared.container.viewContext
        
        var result = [ChatUsers] ()
        
        let fetchrequest : NSFetchRequest<ChatUsers> = ChatUsers.fetchRequest()
        
        
        
        fetchrequest.predicate = NSPredicate(format: " session_id > 0 ")
        
        let sort = NSSortDescriptor(key: "last_message_date", ascending: false)
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
    
    
   
   
    func save_users(driver_users: [driver_users]) {
        let username =  UserDefaults.standard.getUserData()?.user.username ?? ""
        
        guard !username.isEmpty else {
            print("error the username no exist in data")
            return
            
            
        }
        
        let context = PersistenceController.shared.container.viewContext
        
       
        
        driver_users.forEach { driverUser in
            let chatuser : ChatUsers =  ChatUsers(context: context)
            print("\(TAG) driver \(driverUser)")
            let (isExistDriver, _) = self.isExistDriver(driverId: driverUser.driverID)
            
            if !isExistDriver {
                print("\(TAG) no exist the driver")
                chatuser.name =  driverUser.name
                chatuser.driver_id = driverUser.driverID
                chatuser.id = UUID()
                chatuser.user_name = username
                chatuser.user_image_profile = driverUser.pictureName
                
                let session_id = driverUser.session?.id ?? 0
                if session_id == 0 {
                    print("Error \(session_id)")
                }
                chatuser.session_id =  Int64(driverUser.session?.id ?? 0)
                if let last_message = driverUser.lastMessage {
                    chatuser.last_message = last_message.content
                    chatuser.last_message_type = last_message.type.rawValue
                    let dateString  =  driverUser.lastMessage?.createdAt ?? ""
                    let dateSession =  driverUser.session?.createdAt ?? ""
                    if !dateSession.isEmpty || !dateString.isEmpty {
                        chatuser.last_message_date =  parse_date(dateString: dateString , dateSession: dateSession)
                    }
                    
                }
                do {
                    try context.save()
                    
                } catch let error as NSError {
                    
                    print("\(TAG) error the save user \(error)")
                    
                    
                }
                
            } else {
                print("\(TAG) existe the driver")
                updateDriverInfo(driverId: driverUser.driverID, driverUser: driverUser, username: username)
            }
            
        }
    }
   
    func parse_date(dateString : String, dateSession : String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat =   "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_us")

        if dateString.isEmpty {
            if !dateSession.isEmpty {
                if let yourDate = formatter.date(from: dateSession) {
                    return yourDate
 
                }
            }

        } else {
            if let yourDate = formatter.date(from: dateString) {
                return yourDate
            }
        }
        return Date()
    }
     
    func updateUserInfo(driverId : String, newMessageInfo : New_messag_received) {
        let (isExistDriver, resultInfo) = self.isExistDriver(driverId: driverId)
            if let resultInfo1 = resultInfo   {
                let session_received = Session(id: newMessageInfo.session_id, user1ID: newMessageInfo.to_user, user2ID: newMessageInfo.to_user, trip: String(newMessageInfo.trip), createdAt: "", driver_id: newMessageInfo.user_send, updatedAt: "")
                
                let last_message = LastMessage(id: 0, content: newMessageInfo.content, sessionID: newMessageInfo.session_id, createdAt: newMessageInfo.date, updatedAt: newMessageInfo.date, uuid: newMessageInfo.uuid?.uuidString, type: newMessageInfo.type_content, tripNumber: newMessageInfo.trip, user_of_chat: newMessageInfo.to_user)
                
                let driverUsers =  driver_users(name: resultInfo1[0].name ?? "" , driverID: newMessageInfo.user_send, lastTrip: String(newMessageInfo.trip ) , currentTrip:  String(newMessageInfo.trip ), nextTrip:  String(newMessageInfo.trip ), pictureName: "", session: session_received , lastMessage: last_message, lastPosition: nil)
            
              
                if isExistDriver {
                    updateDriverInfo(driverId: newMessageInfo.user_send, driverUser: driverUsers, username: newMessageInfo.to_user)
            
                } else {
                    save_users(driver_users: [driverUsers])
                }
            }
    }
    
    
    func updateOnline(driverId : String) {
        let context = PersistenceController.shared.container.viewContext
        var resultado = [NSManagedObject] ()
        let fetchrequest : NSFetchRequest<ChatUsers> = ChatUsers.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "driver_id == %@", driverId)
        do {
            resultado = try context.fetch(fetchrequest)
            let resultadata = resultado as! [ChatUsers]
            
            if resultadata.count > 0 {
                let chatuser =  resultado[0] as! ChatUsers
                chatuser.online = true
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
    
    func updateDriverInfo(driverId : String, driverUser : driver_users, username: String) {
        let context = PersistenceController.shared.container.viewContext
        var resultado = [NSManagedObject] ()
        let fetchrequest : NSFetchRequest<ChatUsers> = ChatUsers.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "driver_id == %@", driverId)
        do {
            resultado = try context.fetch(fetchrequest)
            let resultadata = resultado as! [ChatUsers]
            
            if resultadata.count > 0 {
                let chatuser =  resultado[0] as! ChatUsers
 
                chatuser.name =  driverUser.name
                chatuser.driver_id = driverUser.driverID
                chatuser.id = UUID()
                chatuser.user_name = username
                chatuser.user_image_profile = driverUser.pictureName
                chatuser.session_id =  Int64(driverUser.session?.id ?? 0)
                if let last_message = driverUser.lastMessage {
                    chatuser.last_message = last_message.content
                    chatuser.last_message_type = last_message.type.rawValue
                    let dateString  =  driverUser.lastMessage?.createdAt ?? ""
                    let dateSession =  driverUser.session?.createdAt ?? ""
                    if !dateSession.isEmpty || !dateString.isEmpty {
                        chatuser.last_message_date =  parse_date(dateString: dateString , dateSession: dateSession)
                    }
                }
                
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
    
    /**
     
     */
    func isExistDriver( driverId : String) -> (Bool, [ChatUsers]?) {
        let context = PersistenceController.shared.container.viewContext
        var result = [ChatUsers] ()
        let fetchrequest : NSFetchRequest<ChatUsers> = ChatUsers.fetchRequest()
        
        fetchrequest.predicate = NSPredicate(format: "driver_id == %@", driverId)
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

    
}
