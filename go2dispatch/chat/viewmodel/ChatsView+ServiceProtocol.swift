//
//  ChatsView+ServiceProtocol.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/17/21.
//

//func newMessage(newMessageReceived : New_messag_received)
//func listOnline(list_online : [String])
//func newMessageChat(m : Message)
//func typing(session_id : Int , username : String)
//func readMessageUUID(uuid : String)
//func readMessageIdSessionId(message_id : Int , session_id : Int)

import Foundation
extension ChatsViewModel : ServiceChatProtocol {
    func allOffOnline() {
        self.user_online = []
        
        if self.chats.count > 0 {
            
            
            
                ChatDataManager.instance.updateAllOff()
            
            DispatchQueue.main.async  {
                self.chats.indices.forEach {
                    self.chats[$0].online = false
                }
                self.elcurrentChat.online = false
            }
        }
    }
    
    func newSession(session_id: Int) {
        //
    }
    
    func openChat(openChatData: ParseDatosOfSocket.OpenChatDataReceived) {
       // update all message no
      
        DispatchQueue.main.async {
            self.messages.indices.forEach {
                self.messages[$0].messageParse.readed = true
            }
        }
        
        DispatchQueue.init(label: "dale", qos: .background).async {
            let chat_data =  ChatDataManager.instance
            if let session_id =  openChatData.session_id {
                chat_data.updateAllReadedMessage(session_id: Int64(session_id))
                if let to_user =  openChatData.user {
                    ApiChat.markAllReaded(session_id: session_id, to_user: to_user, trip_number: 0)
                }
            }
           
        }
    }
    
     
    
    // Update is readed from uuid
    func readMessageUUID(uuid: String) {
        // update search in chat
        DispatchQueue.main.async {
            if let row  = self.messages.firstIndex(where: {$0.messageParse.id.uuidString == uuid}) {
                self.messages[row].messageParse.readed = true
            }
        }
    
       
    }
    
    func readMessageIdSessionId(message_id: Int, session_id: Int) {
     // update
        ApiChat.readMessage(session_id: session_id, message_id: message_id)
    }
    
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
    
 
    func newMessage(newMessageReceived : New_messag_received) {
        isNewMessage = true
         
        ChatDataManager.instance.updateUserInfo(driverId: newMessageReceived.user_send, newMessageInfo: newMessageReceived )
        
        self.newMessageReceived = newMessageReceived
        
        
        updateChats(newMessageReceived: newMessageReceived)
        
        
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
    
    func newMessageChat(m: Message, user_send: String) {
        
       
        let send_at =  DAt(date: "", timezoneType: 3, timezone: Timezone.americaChicago)
       
        let mess =  MessagesList(message: "", id: 0, sessionID: 0, type: 1, readAt: nil, sendAt: send_at , content: .text, trip: 0, uuid: nil, user: "", messageParse: m)
        
        
        self.messages.append(mess)
        self.messageIDToScroll = m.id
        self.count += 1
        DispatchQueue.main.async {
            if let row = self.chats.firstIndex(where: {$0.person.driver_id == user_send}) {
                self.chats[row].messages[0] = m
                self.chats[row].hasUnreadMessage =  false
            }
        }
        
        
    }
    
    func listOnline(list_online: [String]) {
        self.user_online = list_online
        
        if self.chats.count > 0 {
            
            
            for i in 0..<list_online.count {
                ChatDataManager.instance.updateOnline(driverId: list_online[i],isOnline: true)
            }
            DispatchQueue.main.async  {
                self.chats.indices.forEach {
                    self.chats[$0].online = list_online.contains(self.chats[$0].person.driver_id) ?  true :  false
                }
                
                
                let isonline =  self.user_online.contains(self.elcurrentChat.person.driver_id)
                
                    self.elcurrentChat.online = isonline
                
                
            }
        }
    }
}
