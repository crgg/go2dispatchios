//
//  ParseDatosOfSocket.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/13/21.
//

import Foundation

class ParseDatosOfSocket {
    
   public static func parseUsersOnline(data2 : [[String : Any]],  handle: @escaping (_ result : [String]) ->()) {
        
        var list_online : [String] = []
        var i = 0
        while i < data2.count {
            
            if let us = data2[i]["username"] as? String {
                list_online.append(us)
                print("\(Date()) 🎯 is online \(us)")
            }
            i += 1
            if i == data2.count {
                handle(list_online)
            }
        }
    }
    
    
    public static func parseMessageReceived(dataReceived : [String : Any],  handle: @escaping (_ result : DataReceived) ->()) {
        let result = DataReceived(dict: dataReceived)
        handle(result)
        
        
    }
    
    public static func parserOpenChat(dataReceived : Any?, handler: @escaping (_ rr_result: OpenChatDataReceived?) -> ()) {
        if let datos =  dataReceived as? [String : Any] {
                print(datos)
            guard let session_id = datos["session_id"] as? Int else {
                    handler(nil)
                return
            }
            guard let user = datos["user"] as? String else {
                handler(nil)
                return
            }
             handler(OpenChatDataReceived(session_id: session_id, user: user))
        }
    }
}

extension ParseDatosOfSocket {
    struct OpenChatDataReceived {
        var session_id : Int?
        var user : String?
     
    }
    
}

extension ParseDatosOfSocket {
    struct DataReceived {
        var id : Int?
        var date : String?
        var user_send : String?
        var message : String?
        var trip: String?
        var type : Int?
        var user : String?
        var send_at : Send_at?
        var session_id : Int?
        var url : String?
        var uuid : UUID = UUID()
        var status : String = "send"
        var content : String = "text"
        var read_at :  [String : Any]?
        
        init(dict : [String: Any]) {
            if let c = dict["id"] as? Int {
                self.id = c
            }
            if let t = dict["type"] as? Int {
                self.type = t
            }
            if let d = dict["date"]  as? String {
                self.date = d
            }
            if let me = dict["message"] as? String {
                self.message = me
            }
            if let tr = dict["trip"] as? String {
                self.trip = tr
            }
            if let us = dict["to_user"] as? String {
                self.user = us
            }
        
                                    
            if let session_id  = dict["session_id"] as? Int {
                self.session_id = session_id
            } else {
                if let session_id = dict["session_id"] as? String {
                    self.session_id = Int(session_id)
                }
            }
            
            
            if let url = dict["url"] as? String {
                self.url = url
            }
            if let uid =  dict["uuid"] as? String {
                
                if let uui = UUID(uuidString: uid) {
                    self.uuid = uui
                }
                
            } else if let uid = dict["UUID"] as? String {
                self.uuid = UUID(uuidString: uid)!
            }
            
            
            if let sendd = dict["send_at"] as? [String : Any] {
                self.send_at  =  Send_at(da : sendd)
            }
            if let content = dict["content"] as? String {
                self.content = content
            }
            if let readat = dict["read_at"] as? [String: Any] {
                self.read_at =  readat
                self.status = "send"
            } else {
                print(" 🔥 no read at come")
                self.status = "no_read"
                
            }
            if let userSend = dict["user_send"] as? String  {
                self.user_send = userSend
            }
          
            
            if let dataextra = dict["dataextra"] as? [String : Any] {
                if let created_at = dataextra["created_at"] as? String {
                    self.date = created_at
                }
                if let message_id = dataextra["message_id"] as? Int {
                    self.id = message_id
                }
                if let session_id = dataextra["session_id"] as? Int  {
                    self.session_id =  session_id
                }
                if let type_msg = dataextra["type"] as? Int {
                    self.type = type_msg
                }
                if let user_id = dataextra["user_id"] as? String {
                    self.user_send = user_id
                }
                
            }
            
            
        }
        
    }
    struct Send_at {
        var date_ms : String?
        init(da : [String : Any]) {
            if let fecha = da["date"] as? String {
                self.date_ms = fecha
            }
            
        }
    }
}
