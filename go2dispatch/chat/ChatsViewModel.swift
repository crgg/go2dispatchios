//
//  ChatsViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/30/21.
//

import Foundation
import SwiftUI
import simd

class ChatsViewModel: ObservableObject {
    
    @Published var chats = [Chat]()
    @Published var chatsDriverAll = [Chat]()
    
    
    @ObservedObject var service = Service()
    
    init() {
//        fetchUsers()
    }
    
    func fetchUsers() {
        ApiChat.getUsers { sucess, error, data  in
            if let error = error {
                print(error  )
            }
            
            if data.count > 0 {
                var ch = [Chat]()
                for user_d in data {
                    
                    
                    let dateString  =  user_d.lastMessage?.createdAt ?? ""
                    
                    
                    var dateResult = Date()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat =   "yyyy-MM-dd HH:mm:ss"
                    formatter.locale = Locale(identifier: "en_us")
                    
                    if dateString.isEmpty {
                        let dateSession = user_d.session?.createdAt ?? ""
                        if !dateSession.isEmpty {
                            if let yourDate = formatter.date(from: dateSession) {
                                dateResult = yourDate
                                
                            }
                        }
                        
                    } else {
                        if let yourDate = formatter.date(from: dateString) {
                            dateResult =  yourDate
                        }
                    }
                    
                    
                    let c =  Chat(person: Person(name: user_d.name, driver_id: user_d.driverID, imgString: user_d.pictureName), messages : [
                        Message(user_d.lastMessage?.content ?? "", type: .send, date: dateResult)
                    ], hasUnreadMessage: false)
                    ch.append(c)
                }
                DispatchQueue.main.async {
                    self.chats = ch
                }
            }
            
           
            
        }
    }
    
    
    func fetchAllUsers() {
        ApiChat.getAllUsers { sucess, error, data  in
            if let error = error {
                print(error  )
            }
            
            if data.count > 0 {
                var ch = [Chat]()
                for user_d in data {
                    
                    let dateString  =  user_d.lastMessage?.createdAt ?? ""
                    
                    var dateResult = Date()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat =   "yyyy-MM-dd HH:mm:ss"
                    formatter.locale = Locale(identifier: "en_us")
                    
                    var message = [Message]()
                    
                    if !dateString.isEmpty {                       
                        if let yourDate = formatter.date(from: dateString) {
                            dateResult =  yourDate
                            message.append(Message(user_d.lastMessage?.content ?? "", type: .send, date: dateResult))
                        }
                    }
                    
                    
                    let c =  Chat(person: Person(name: user_d.name, driver_id: user_d.driver_id, imgString: user_d.picture_name), messages : message, hasUnreadMessage: false)
                    
                    
                    ch.append(c)
                }
                DispatchQueue.main.async {
                    self.chatsDriverAll = ch
                }
            }
            
           
            
        }
    }
    
    func getSortedFilteredChatsAllDrivers(query : String) -> [Chat] {
        let sortedChats = chatsDriverAll.sorted {
            guard let date1 = $0.messages.last?.date else { return false  }
            guard let date2 = $1.messages.last?.date else { return false }
            return date1 > date2
        }
        if query == "" {
            return sortedChats
        }
        return sortedChats.filter { $0.person.driver_id.lowercased().contains(query.lowercased())
                                      || $0.person.name.lowercased().contains(query.lowercased())
            
        }
        
        
    }
    
    
    func getSortedFilteredChats(query : String) -> [Chat] {
        let sortedChats = chats.sorted {
            guard let date1 = $0.messages.last?.date else { return false  }
            guard let date2 = $1.messages.last?.date else { return false }
            return date1 > date2
        }
        if query == "" {
            return sortedChats
        }
        return sortedChats.filter { $0.person.name.lowercased().contains(query.lowercased())
            || $0.person.name.lowercased().contains(query.lowercased())
        }
        
        
    }
    
    func getSectionMessage(for chat : Chat) -> [[Message]]{
        
        var res =  [[Message]]()
        var tmp = [Message]()
        for message in chat.messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date)
                if daysBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                } else {
                    tmp.append(message)
                }
        
            } else {
                tmp.append(message)
            }
        }
        res.append(tmp)
        return res
        
    }
    
    
    func markAsUnread(_ newValue: Bool, chat: Chat) {
        if let index = chats.firstIndex(where: {$0.id == chat.id}) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    func sendMessage(_ text: String, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id}) {
            let message = Message(text, type: .send)
            chats[index].messages.append(message)
            return message
        }
        return nil
    }
    
}
