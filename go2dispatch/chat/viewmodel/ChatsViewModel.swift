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
    @Published var elcurrentChat = Chat.sampleChat[0]
    @Published var countMessage : Int = 0
    @Published var  messagesResumen : [[Message]] = []
    
    @ObservedObject var service = Service()
    
    var user_online : [String] = []
    

    

 
    init() {
//        fetchUsers()
        service.callback = self
      
    }
   
    deinit {
        
        print("DEINITIALIZE NOW!!!")
        
    }

    
    func setElCurrentChat(chat: Chat) {
        self.elcurrentChat = chat
    }
    func getElCurrentChat() -> Chat {
        return elcurrentChat
    }
    
    func fetchUsers()  {
        
        
        if let username = UserDefaults.standard.getUserData()?.user.username {
            let (status, result) = ChatDataManager.instance.getAllUserWithMessageMe(usernameID: username )
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
                    DispatchQueue.main.async { [weak self] in
                        self?.message_error.isMessageError = true
                        self?.message_error.messageErrorText = error
                    }
                }
                return
            }

            if data.count > 0 {
                DispatchQueue.main.async { [weak self] in
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

                        let isonline =  self?.user_online.contains(user_d.driverID)
                        
                        let c =  Chat(person: Person(name: user_d.name, driver_id: user_d.driverID,
                                                     imgString: user_d.pictureName), messages : [

                                                        Message(user_d.lastMessage?.content ?? "", type: whosendms, date: dateResult, content_type: content_type,
                                                                userOwn: user_d.lastMessage?.user_of_chat ?? "" ,  messageId: user_d.lastMessage?.id ?? 0)
                                                     ], hasUnreadMessage: false, online: isonline ?? false, session_id: user_d.session?.id ?? 0)
                        
                    
                        if let row = self?.chats.firstIndex(where: {$0.person.driver_id == user_d.driverID}) {
                            self?.chats[row].person.name = user_d.name
                            self?.chats[row].person.driver_id = user_d.driverID
                            self?.chats[row].person.imgString = user_d.pictureName
                            self?.chats[row].messages[0].text = user_d.lastMessage?.content ?? ""
                            self?.chats[row].messages[0].type = whosendms
                            self?.chats[row].messages[0].date = dateResult
                            self?.chats[row].messages[0].content_type = content_type
                            self?.chats[row].session_id  = user_d.session?.id ?? 0
                        } else {
                            self?.chats.append(c)
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
            
            let c =  Chat(person: Person(name: user_d.name ?? "", driver_id: user_d.driver_id ?? "", imgString: user_d.user_name ?? ""), messages : [
                
                Message(user_d.last_message ?? "", type: whosendms, date: dateResult, content_type: content_type, userOwn : user_d.last_message_user_of_chat ?? "" , messageId: 0)
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
                            if whosend == user_d.driverID {
                                whosendms = MessageType.send
                                
                            }
                        }
                        
                        
                        if let yourDate = formatter.date(from: dateString) {
                            dateResult =  yourDate
                            message.append(Message(user_d.lastMessage?.content ?? "", type: .send, date: dateResult, content_type: content_type,
                                                   userOwn: user_d.lastMessage?.user_of_chat ?? "" , messageId: user_d.lastMessage?.id ?? 0))
                        }
                    }
                    
                 
                    
                    let c =  Chat(person: Person(name: user_d.name, driver_id: user_d.driverID, imgString: user_d.pictureName), messages : message, hasUnreadMessage: false, session_id: user_d.lastMessage?.sessionID ?? 0)
                    
                    
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
    
    
    func sendMessage2(_ text: String, chat : Chat ,
                      handler: @escaping (_ status : Bool, _ result: Message?)->()) {
        var chatTemp = chat
        if  chat.session_id == 0 {
            print(" \(Service.logs_chat) chatRoom: SEND_MESSAGE : Session is Null")
            
            ApiChat.createSession(driver_id: chat.person.driver_id, trip_number: 0)  { [weak self] sucess, error, result in
                if let error = error {
                    self?.message_error.isMessageError = true
                    self?.message_error.messageErrorText = error
                    handler(false, nil )
                    return
                }
                if let result = result {
                    chatTemp.session_id =  result
                    ApiChat.insertMessage(msg: text, chat: chatTemp) { [weak self] sucess, error, result in
                        if let error = error {
                            print("Error \(error)")
                            self?.message_error.isMessageError = true
                            self?.message_error.messageErrorText = error
                           
                            return
                        }
                        if result == nil {
                            self?.message_error.isMessageError = true
                            self?.message_error.messageErrorText = "unknow error"
                            handler(false, nil )
                            return
                        }
                        guard let messageid = result?.messageID else {
                            self?.message_error.isMessageError = true
                            self?.message_error.messageErrorText = "unknow error"
                            handler(false, nil )
                            return
                            
                        }
                        
                        print("\(Service.logs_chat) emit Chat")
                        
                        
                        
                        var dateCreate = Date()
                        if let datecreated = result?.createdAt {
                            if let dateCreate1 = UtilDate.parseDate(dateString: datecreated) {
                                dateCreate = dateCreate1
                            }
                        }
                        
                        
                        
                        let message = Message(text, type: .send, content_type: .text,
                                              readed: false, date: dateCreate, userOwn: "", messageId: messageid                        )
                        let send_at =  DAt(date: "", timezoneType: 3, timezone: Timezone.americaChicago)
                       
                        let mess =  MessagesList(message: text, id: 0, sessionID: chatTemp.session_id, type: 1, readAt: nil, sendAt: send_at , content: .text, trip: 0, uuid: nil, user: "", messageParse: message)
                        
                        
                        chatTemp.messages.append(message)
                        
                        DispatchQueue.main.async {
                            self?.messages.append(mess)
                            self?.countMessage += 1
                            self?.service.sendMessage(msg: text, dateCreated: result?.createdAt ?? "", chat: chatTemp, uuid : message.id)
                            handler(true, message)
                            
                            ChatDataManager.instance.insertMessage(chat: chatTemp)
                        }
                        
                            
                    }
                } else {
                    handler(false, nil)
                    self?.message_error.isMessageError = true
                    self?.message_error.messageErrorText = "unknow error"
                    return
                }
            }
        } else {
            ApiChat.insertMessage(msg: text, chat: chatTemp) { [weak self] sucess, error, result in
                if let error = error {
                    print("Error \(error)")
                    self?.message_error.isMessageError = true
                    self?.message_error.messageErrorText = error
                   
                    return
                }
                if result == nil {
                    self?.message_error.isMessageError = true
                    self?.message_error.messageErrorText = "unknow error"
                    handler(false, nil )
                    return
                }
                guard let messageid = result?.messageID else {
                    self?.message_error.isMessageError = true
                    self?.message_error.messageErrorText = "unknow error"
                    handler(false, nil )
                    return
                    
                }
                
                print("\(Service.logs_chat) emit Chat")
                
                ChatDataManager.instance.insertMessage(chat: chatTemp)
                
                var dateCreate = Date()
                if let datecreated = result?.createdAt {
                    if let dateCreate1 = UtilDate.parseDate(dateString: datecreated) {
                        dateCreate = dateCreate1
                    }
                }
                
                
                
                let message = Message(text, type: .send, content_type: .text,
                                      readed: false, date: dateCreate, userOwn: "", messageId: messageid                        )
                let send_at =  DAt(date: "", timezoneType: 3, timezone: Timezone.americaChicago)
               
                let mess =  MessagesList(message: text, id: 0, sessionID: chat.session_id, type: 1, readAt: nil, sendAt: send_at , content: .text, trip: 0, uuid: nil, user: "", messageParse: message)
                DispatchQueue.main.async {
                    self?.messages.append(mess)
                    chatTemp.messages[0] = message
                    
                    self?.countMessage += 1
                    self?.service.sendMessage(msg: text, dateCreated: result?.createdAt ?? "", chat: chatTemp, uuid : message.id)
                    handler(true, message)
                }
                
                    
            }
        }

 
   
        

 
            
        

    }
    
  
    func didSelectImage(_ image: UIImage?, chat : Chat) {
        
     
        
        
        
        if let imageThumb1 = image?.resized(toWidth: 900.0) {
            
            let message = Message("", type: .send, content_type: .image,
                                  readed: false, date: Date(), userOwn: "", messageId: 0)
            let send_at =  DAt(date: "", timezoneType: 3, timezone: Timezone.americaChicago)
            
            let localFilemanager = LocalFileManager.instance
            localFilemanager.saveImage(image: imageThumb1, name: message.id.uuidString)
            print("🤳 save picture uuid \(message.id.uuidString)")
                     
            let mess =  MessagesList(message:  message.id.uuidString, id: 0, sessionID: chat.session_id, type: 1, readAt: nil, sendAt: send_at , content: .image, trip: 0, uuid: nil, user: "", messageParse: message)
            DispatchQueue.main.async {
                self.messages.append(mess)
                self.countMessage += 1
            }
            
            var chatemp = chat
            chatemp.messages = []
            chatemp.messages.append(message)
            
            ApiChat.sendMedia(msg: "image", chat: chat, image_data: imageThumb1.jpegData(compressionQuality: 0.75) ) { [weak self]  sucess, error, result in
                print("dale")
                if let error = error {
                    print("🤳 Error \(error)")
                    DispatchQueue.main.async {
                        self?.message_error.isMessageError = true
                        self?.message_error.messageErrorText = "Unknow error try again"
                    }
                    return
                }
                
                if let result  = result {
                    guard let text = result.message else {
                        print("🤳 No received a text")
                        return
                    }
                    guard let type = result.type else {
                        print("🤳 No received a type of send o received")
                        return
                    }
                    
                    guard let sendat = result.send_at else {
                        print("🤳 no found object send at")
                        return
                    }
                
                    
                    guard let dateMessage = sendat.date else {
                        print("🤳 No received a date Message")
                        return
                    }
                    guard  let dateFormat = UtilDate.parseDate(dateString: dateMessage) else {
                        print("🤳 format the date is incorrecty")
                        return
                    }
                                        
                    guard let content_type = result.content else {
                        print("🤳 No received a content type")
                        return
                    }
                    var type_content : contentType
                    switch content_type {
                        case "text":
                        type_content =  .text
                    case "video":
                        type_content = .video
                    default:
                        type_content = .image
                        
                    }
                    guard let mesage_id =  result.id  else {
                        print("🤳 No tenemos un mensaje de id")
                        return
                    }
                    
                    let message = Message(text, type: .send, content_type: type_content,
                                          readed: false, date: dateFormat, userOwn: "", messageId: 0)
                    let send_at =  DAt(date: dateMessage, timezoneType: 3, timezone: Timezone.americaChicago)
                    
                    let mess =  MessagesList(message: text, id: 0, sessionID: chat.session_id, type: 1, readAt: nil, sendAt: send_at , content: .text, trip: 0, uuid: nil, user: "", messageParse: message)
                   
//                    DispatchQueue.main.async {
//
//
//                        ChatDataManager.instance.insertMessage(chat: mess)
//                    }
//
//
                    
                }
                
                
                
                
                
            }
        } else {
//
            ApiChat.sendMedia(msg: "image", chat: self.elcurrentChat, image_data: image?.jpegData(compressionQuality: 0.5) ) { sucess, error, result in
                print("dale")
                
            }
        }
             
//               isPresentingImagePicker = false
    }
    
    func sendMessage(_ text: String, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id}) {
            let message = Message(text, type: .send, content_type: .text, userOwn: "", messageId: 0)
            chats[index].messages.append(message)
            return message
        }
        return nil
    }
    
    func getIsNewMessage() -> Bool {
        return isNewMessage
    }
    
    
    
}
