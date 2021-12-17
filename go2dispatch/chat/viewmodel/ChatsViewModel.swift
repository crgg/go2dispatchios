//
//  ChatsViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/30/21.
//

import Foundation
import SwiftUI
import simd

struct MessageError {
    var isMessageError : Bool = false
    var messageErrorText : String = ""
}

class ChatsViewModel: ObservableObject, ServiceChatProtocol {
    func typing(session_id: Int, username: String) {
        // search in chat
        isTyping =  true
        
        _  = Timer.scheduledTimer(timeInterval: 3.0,
                                  target: self,
                                  selector: #selector(stopTyping),
                                  userInfo: nil,
                                  repeats: true)
        
    }
    @objc func stopTyping() {
        
       isTyping = false
    }
    
 
    func newMessageChat(m: Message) {
        self.messages.append(m)
    
    }
    
    @Published var isTyping =  false
    @Published var chats = [Chat]()
    @Published var messages = [Message]()
    @Published var chatsDriverAll = [Chat]()
    @Published var isNewMessage = false
    @Published var message_error : MessageError  = MessageError()
    
    
    @Published var newMessageReceived : New_messag_received = New_messag_received()
 
    
    @ObservedObject var service = Service()
    var user_online : [String] = []
    
    
    func listOnline(list_online: [String]) {
        self.user_online = list_online
        
        if self.chats.count > 0 {
            
            let chatdat = Chata_data()
            for i in 0..<list_online.count {
                chatdat.updateOnline(driverId: list_online[i])
            }
            DispatchQueue.main.async  {
                self.chats.indices.forEach {
                    self.chats[$0].online = list_online.contains(self.chats[$0].person.driver_id) ?  true :  false
                }
            }
        }
    }
    
    func newMessage(newMessageReceived : New_messag_received) {
        isNewMessage = true
        let chatdata = Chata_data()
        chatdata.updateUserInfo(driverId: newMessageReceived.user_send, newMessageInfo: newMessageReceived )
        
        self.newMessageReceived = newMessageReceived
        
        
        updateChats(newMessageReceived: newMessageReceived)
        
        
    }
    

 
    init() {
//        fetchUsers()
        service.callback = self
      
    }

    func updateChats(newMessageReceived : New_messag_received) {
        if self.chats.count == 0 {
            return
        }
        DispatchQueue.main.async {
            if let row = self.chats.firstIndex(where: {$0.person.driver_id == newMessageReceived.user_send}) {
                self.chats[row].messages[0].text = newMessageReceived.message
                self.chats[row].hasUnreadMessage =  true
            }
        }
    }
    
    
    func fetchUsers()  {
        
        let chatdata = Chata_data()
        if let username = UserDefaults.standard.getUserData()?.user.username {
          let (status, result) = chatdata.getAllUserWithMessageMe(usernameID: username )
            if status {
                if let r = result {
                    parseUserInfo(data: r)
                    fromApi()
                }
            } else {
                fromApi()
            }
        }
        
        
    }
    
    
    func fromApi() {
        ApiChat.getUsers { sucess, error, data  in
            if !sucess {
                if let error = error {
                    print(error  )
                    DispatchQueue.main.async {
                        self.message_error.isMessageError = true
                        self.message_error.messageErrorText = error
                    }
                }
                return
            }

            if data.count > 0 {
                DispatchQueue.main.async {
                    for user_d in data {
                        
                        if user_d.session?.id == 0 {
                            print("session id is 0")
                        }

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

                        let  content_type = user_d.lastMessage?.type == .text ? contentType.text : contentType.image
                        var whosendms = MessageType.received
                        if let whosend = user_d.lastMessage?.user_of_chat {
                            if whosend == user_d.driverID {
                                whosendms = MessageType.send

                            }
                        }

                        let isonline =  self.user_online.contains(user_d.driverID)
                        
                        let c =  Chat(person: Person(name: user_d.name, driver_id: user_d.driverID, imgString: user_d.pictureName), messages : [

                            Message(user_d.lastMessage?.content ?? "", type: whosendms, date: dateResult, content_type: content_type)
                        ], hasUnreadMessage: false, online: isonline)
                        
                    
                        if let row = self.chats.firstIndex(where: {$0.person.driver_id == user_d.driverID}) {
                            self.chats[row].person.name = user_d.name
                            self.chats[row].person.driver_id = user_d.driverID
                            self.chats[row].person.imgString = user_d.pictureName
                            self.chats[row].messages[0].text = user_d.lastMessage?.content ?? ""
                            self.chats[row].messages[0].type = whosendms
                            self.chats[row].messages[0].date = dateResult
                            self.chats[row].messages[0].content_type = content_type
                            self.chats[row].session_id  = user_d.session?.id ?? 0
                        } else {
                            self.chats.append(c)
                        }
                        
              
                    }
                }
            
               
            }



        }
    }
    
    func parseUserInfo(data : [ChatUsers]) {
        var ch = [Chat]()
        for user_d in data {
            
            if user_d.session_id == 0  {
                print(user_d)
            }
            
            
            let dateResult  = user_d.last_message_date ?? Date()
            var whosendms = MessageType.received
            if let user_chat_of_chat = user_d.last_message_user_of_chat {
                if user_chat_of_chat == user_d.driver_id {
                    whosendms = MessageType.send
                }
            }
            
            let content_type = user_d.last_message_type == "text" ? contentType.text : contentType.image
            
            let isonline =  self.user_online.contains(user_d.driver_id ?? "")
            
            let c =  Chat(person: Person(name: user_d.name ?? "", driver_id: user_d.driver_id ?? "", imgString: user_d.user_image_profile ?? ""), messages : [
                
                Message(user_d.last_message ?? "", type: whosendms, date: dateResult, content_type: content_type)
            ], hasUnreadMessage: false, online: isonline, session_id: Int(user_d.session_id ))
            
            
            
            
            
            ch.append(c)
        }
//        DispatchQueue.main.async {
            self.chats = ch
//        }
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
                        let  content_type = user_d.lastMessage?.type == .text ? contentType.text : contentType.image
                        var whosendms = MessageType.received
                        if let whosend = user_d.lastMessage?.user_of_chat {
                            if whosend == user_d.driver_id {
                                whosendms = MessageType.send
                                
                            }
                        }
                        
                        
                        if let yourDate = formatter.date(from: dateString) {
                            dateResult =  yourDate
                            message.append(Message(user_d.lastMessage?.content ?? "", type: .send, date: dateResult, content_type: content_type))
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
    

    func setCurrentChat(chat : Chat) {
        service.currenChat = chat
    }
    
    func markAsUnread(_ newValue: Bool, chat: Chat) {
        if let index = chats.firstIndex(where: {$0.id == chat.id}) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    
    func sendMessage2(_ text: String, chat : Chat) -> Message {
        
        
        
        
        let message = Message(text, type: .send, content_type: .text)
        self.messages.append(message)
    
        service.sendMessage(msg: text, chat: chat)
        return message
    }
    
    func sendMessage(_ text: String, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id}) {
            let message = Message(text, type: .send, content_type: .text)
            chats[index].messages.append(message)
            return message
        }
        return nil
    }
    
    func getIsNewMessage() -> Bool {
        return isNewMessage
    }
    
}