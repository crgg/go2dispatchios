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

class ChatsViewModel: ObservableObject  {
   
    
    @Published var messageIDToScroll : UUID?
    
    @Published var isTyping =  false
    @Published var chats = [Chat]()
    @Published var messages = [MessagesList]()
    @Published var chatsDriverAll = [Chat]()
    @Published var isNewMessage = false
    @Published var message_error : MessageError  = MessageError()
    @Published var newMessageReceived : New_messag_received = New_messag_received()
    
    @ObservedObject var service = Service()
    
    var user_online : [String] = []
    

    

 
    init() {
//        fetchUsers()
        service.callback = self
      
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
                        print(user_d)
                        assert(user_d.session?.id ?? 0 > 0 )
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
                        
                        let c =  Chat(person: Person(name: user_d.name, driver_id: user_d.driverID,
                                                     imgString: user_d.pictureName), messages : [

                            Message(user_d.lastMessage?.content ?? "", type: whosendms, date: dateResult, content_type: content_type)
                        ], hasUnreadMessage: false, online: isonline, session_id: user_d.session?.id ?? 0)
                        
                    
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
            
            assert(user_d.session_id > 0)
            
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
        
        
        
        
        let message = Message(text, type: .send, content_type: .text, readed: false)
        let send_at =  DAt(date: "", timezoneType: 3, timezone: Timezone.americaChicago)
       
        let mess =  MessagesList(message: text, id: 0, sessionID: chat.session_id, type: 1, readAt: nil, sendAt: send_at , content: .text, trip: 0, uuid: nil, user: "", messageParse: message)
        
        self.messages.append(mess)
    
        service.sendMessage(msg: text, chat: chat, uuid : message.id)
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
