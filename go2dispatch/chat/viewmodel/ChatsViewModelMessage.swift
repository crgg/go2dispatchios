//
//  ChatViewModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
extension ChatsViewModel {
    
 
    
    func getSectionMessage(for chat : Chat) -> [[Message]]{
        
        var res =  [[Message]]()
        var tmp = [Message]()
        for message in messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.messageParse.date)
                if daysBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message.messageParse)
                } else {
                    tmp.append(message.messageParse)
                }
        
            } else {
                tmp.append(message.messageParse)
            }
        }
//        print("🧩 \(Date() ) parse ")
        res.append(tmp)
        return res
        
    }
    
    func getMessages(session_id : Int) {
        guard session_id > 0 else {
            DispatchQueue.main.async {
                self.message_error.isMessageError = true
                self.message_error.messageErrorText =  "Session id is 0"
            }
            return
        }
        
        
        
//
        
//        let (status, result) = ChatDataManager.instance.getMessages(session_id: Int64(session_id))
////        guard result != nil else {
////            return
////        }
//        
//        if status {
//            DispatchQueue.main.async {
//                if let row = self.chats.firstIndex(where: {$0.session_id == session_id}) {
//                    self.chats[row].messages = []
//                    result?.forEach({ c in
//                        
//                        
//                        let type =  c.type == 0 ?  MessageType.send : MessageType.received
//                        let contentType = c.content == "Text" ? contentType.text : contentType.image
//                        
//                        self.chats[row].messages.append( Message(c.message ??  "", type: type, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: contentType))
//                        
//                    })
//                    
//                }
//            }
//          //  return
//        }
//
        
        print("🧩 \(Date()) Server get Message")
        ApiChat.getMessages(session_id: session_id){ sucess, error, data in
            if !sucess {
                if let error = error {
                    DispatchQueue.main.async {
                        self.message_error.isMessageError = true
                        self.message_error.messageErrorText = error
                    }
                }
                return
            }
            if  data.count > 0 {
                print("🧩\(Date()) Server finined Get Message")
                DispatchQueue.main.async {
                    
                    self.messages =  data
                    self.messagesResumen = self.getSectionMessage(for: Chat.sampleChat[0])
                    self.messageIDToScroll = data.last?.messageParse.id
                    print("🧩\(Date()) last is \( String(describing: self.messages.last?.id))")
                    print("🧩\(Date()) Assign UI")
                    DispatchQueue.main.async {
                        self.countMessage = data.count
                    }
                }
            }
            
        }
    }
   
    
    
}
 
