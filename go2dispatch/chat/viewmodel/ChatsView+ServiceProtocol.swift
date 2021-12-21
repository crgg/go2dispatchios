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
    func newSession(session_id: Int) {
        //
    }
    
    func openChat(openChatData: ParseDatosOfSocket.OpenChatDataReceived) {
       // update all message no
      
        DispatchQueue.main.async {
            self.messages.indices.forEach {
                self.messages[$0].readed = true
            }
        }
        
        DispatchQueue.init(label: "dale", qos: .background).async {
            let chat_data =  Chata_data()
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
            if let row  = self.messages.firstIndex(where: {$0.id.uuidString == uuid}) {
                self.messages[row].readed = true
            }
        }
    }
    
    func readMessageIdSessionId(message_id: Int, session_id: Int) {
     // update
        
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
        let chatdata = Chata_data()
        chatdata.updateUserInfo(driverId: newMessageReceived.user_send, newMessageInfo: newMessageReceived )
        
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
        self.messages.append(m)
        self.messageIDToScroll = m.id
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
}