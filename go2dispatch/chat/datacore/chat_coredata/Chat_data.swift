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

class Chata_data {
     
    let TAG : String = "💬 CHAT_DATA"
    
    
    
    
    
    func save_users(driver_users: [driver_users]) {
        
        let context = PersistenceController.shared.container.viewContext
        
        let chatuser : ChatUsers =  ChatUsers(context: context)
        
        driver_users.forEach { driverUser in
            
            print("\(TAG) driver \(driverUser)")
            let (isExistDriver, _) = self.isExistDriver(driverId: driverUser.driverID)
            
            if !isExistDriver {
                print("\(TAG) no exist the driver")
                chatuser.name =  driverUser.name
                chatuser.driver_id = driverUser.driverID
                chatuser.id = UUID()
                chatuser.session_id =  Int64(driverUser.session?.id ?? 0)
                if let last_message = driverUser.lastMessage {
                    chatuser.last_message = last_message.content
                    chatuser.last_message_type = last_message.type.rawValue
                }
                
                do {
                    try context.save()
                    
                } catch let error as NSError {
                    
                    print("\(TAG) error the save user \(error)")
                    
                    
                }
                
            } else {
                print("\(TAG) existe the driver")
                
            }
            
        }
    }
   
    func updateDriverInfo(driverId : String, driver_users : driver_users) {
        let context = PersistenceController.shared.container.viewContext
        var resultado = [NSManagedObject] ()
        let fetchrequest : NSFetchRequest<ChatUsers> = ChatUsers.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "driver_id == %@", driverId)
        do {
            resultado = try context.fetch(fetchrequest)
            let resultadata = resultado as! [ChatUsers]
            
            if resultadata.count > 0 {
                let objeto =  resultado[0] as! ChatUsers
                 objeto.user_name = driver_users.name
                
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
    func isExistDriver( driverId : String) -> (Bool, [NSManagedObject]?) {
        let context = PersistenceController.shared.container.viewContext
        var result = [NSManagedObject] ()
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
