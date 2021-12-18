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
    
    func getMessages(session_id : Int) {
        guard session_id > 0 else {
            DispatchQueue.main.async {
                self.message_error.isMessageError = true
                self.message_error.messageErrorText =  "Session id is 0"
            }
            return
        }
        
        
        
        let chatdata =  Chata_data()
        
//        let (status, result) = chatdata.getMessages(session_id: Int64(session_id))
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
        ApiChat.getMessages(session_id: session_id) { sucess, error, data in
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
                
                    DispatchQueue.main.async {
                        if let row = self.chats.firstIndex(where: {$0.session_id == session_id}) {
//                            self.chats[row].messages = []
                            var messages1 = [Message]()
                            data.forEach({ c in
                                
                                let type =  c.type == 0 ?  MessageType.send : MessageType.received
                                let type_content = c.content.rawValue == "text" ? contentType.text : contentType.image
                                
                                let dateString  =  c.sendAt.date
                                var dateResult = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat =   "yyyy-MM-dd HH:mm:ss.000000"
                                formatter.locale = Locale(identifier: "en_us")
                                if let yourDate = formatter.date(from: dateString) {
                                    dateResult =  yourDate
                                }
                                
                                messages1.append(Message(c.message , type: type, date: dateResult, content_type: type_content))
                                
//                                self.chats[row].messages.append( Message(c.message , type: type, date: dateResult, content_type: type_content))
                                
                            })
//                            self.chats[row].messages = messages1
                            self.messages = messages1
                            self.messageIDToScroll = messages1.last?.id
                            
                        }
                    }
                    
                
                
            }
            
            
        }
            
        
        
        
  
    }
   
    
    
}
