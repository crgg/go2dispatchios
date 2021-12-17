//
//  Service.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/4/21. yesx
//

import Foundation
import SocketIO
import SwiftLocation

protocol ServiceChatProtocol {
    func newMessage(newMessageReceived : New_messag_received)
    func listOnline(list_online : [String])
    func newMessageChat(m : Message)
    func typing(session_id : Int , username : String)
}

final class Service : ObservableObject {
    
//    , .forceWebsockets(true),
//    , .forceNew(true), .forceWebsockets(true), .forcePolling(false)
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:3001")!,
                                        config: [.log(true), .compress,
                                                 .extraHeaders(["Authorization":"VhCxBC3c1a9jSmoJAdhtvGj6lBtKfPGoXVGSTCMoYOzeEAkchbzjmvHxBQx6"])])
    @Published var messages = [String]()
    @Published var online = [String]()
    @Published var isNewMessage = false
    @Published var message_txt = false
    @Published var currenChat : Chat = Chat.sampleChat[0]
    
   var callback : ServiceChatProtocol?
  
    
    var socket: SocketIOClient?
    
    init() {
        callback = nil
        
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) {  (data, ack) in
            
            print("🎯 conneted")
            self.registerUser()
                 
        }
        
        socket?.on("getUsersConnected") { data , ack in
            print("\(Date()) 🎯 get user rcl")
            if let datareceived = data as? [[String: Any]] {
                if  let data2 = datareceived[0]["clientsDriver"] as? [[String : Any]] {
                    ParseDatosOfSocket.parseUsersOnline(data2: data2) {
                        (list_online) in
                        self.callback?.listOnline(list_online: list_online)
                    }
                }
            }
        }
        socket?.on(clientEvent: .error) { data, ack in
            if let errorStr: String = (data[0] as? String) {
                if errorStr.hasPrefix("ERR_SOCKETIO_INVALID_SESSION") {
                    self.socket?.disconnect()
                    print("App Chat: error \(errorStr)")
                     return
                }
                    
                 if errorStr == "Tried emitting when not connected" {
                     print(errorStr)
                     return
                 }
              }
            
        }
        
        socket?.on("chat") { data, ack in
            
            if let dict  = data[0] as? [String : Any] {
                
                ParseDatosOfSocket.parseMessageReceived(dataReceived: dict) { result in
                    var ctype : contentType = .text
                    switch result.content {
                        case "text":
                        ctype = .text
                        case "image":
                        ctype = .image
                    default :
                        ctype = .video
                    }
                    
                    let contentType : MessageType = result.type == 0 ?  .received : .send
                
                    
                    let m = Message(result.message ?? "", type: contentType, date: UtilDate.parseDate(dateString: result.date!)!   , content_type: ctype)
                    
                    self.callback?.newMessageChat(m: m)
   
                    self.currenChat.messages[0] = m
                    let c : Chata_data = Chata_data()
                    c.insertMessage(chat: self.currenChat)
                }
                
            }
        }
        socket?.on("newIdMessage2") {  data , ack in
            
            if let dict = data[0] as? [String: Any] {
              let newMessage =   New_messag_received(dict)
                self.callback?.newMessage(newMessageReceived: newMessage)
                
            }
        }
        
        
        socket?.on(clientEvent: .disconnect) {  data , ack in
            print("🎯 socket discount")
            
        }
        
        socket?.on("openedchat") {
            data, ack in
            print("socket openedchat")
            
        }
        socket?.on("new_session") { data , ack in
            print("create a nuevo session")
        }
        socket?.on("typing") {
              data, ack in
            if let result  = data[0] as? [String : Any] {
//                g ["session_id": 274, "user": RAMON, "from": PHONE]
                print("typing \(result)")
                if let session_id = result["session_id"] as? Int, let user = result["user"] as? String {
                    
                    self.callback?.typing(session_id: session_id, username: user)
                }
                
                
                
                
            }
            
        }
        socket?.on("chat_pend") { data, ack in
            print("chat_pend")
        }
        
        socket?.on("no-read") {
            data , ack in
            print("no-read")
        }
        socket?.on("openedchatwebforphone") { data, ack in
            print("openedfromwebsite")
        }
        
        socket?.on("messages") { data, ack in
            //                    print(data)
            if let data_ = data[0] as? [[String : Any]] {
                print("Received message")
                
            }
            
        }
        
        socket?.on("sever_error") {
            data, ack in
            print("sever error")
            
        }
        
        socket?.on("readMessage") { data, ack in
           print(" ✏️ read the message")
        }
        

        
        //if !socket.status.active {
        socket?.connect()
        socket?.emit("check_user_online")
        
        
        
        
        
      // }
    }
    
    // MARK : Actiones
    
    
    // Esto esto es solo para driver por ellos si usan mucho esto. para enviar el token"
    func set_header(driverId : String, session_id : Int) {
        
        guard let username = UserDefaults.standard.getUserData()?.user.username else {
            return
        }
        
        let param  = ["token" : UserDefaults.standard.getApiToken() ?? "",
                      "session_id" :  session_id,
                      "user": username,
                      "driver" : driverId,
                      "trip_number" : "11223",
                      "message_id" : 0
            
            ] as [String : Any]
        
        // set headet para autorizacion for user the server.
        print( "✏️ chatRoom: emit set-header \(param)")
       
        socket?.emit("set-header", param,"s")
    }
    
    func join_room(chat : Chat) {
        guard let username = UserDefaults.standard.getUserData()?.user.username else {
            print("No have User name ")
            return
        }
        guard chat.session_id > 0 else {
            return
        }
        
        let param3 : [String : Any] = ["user1_id" : username,
                                       "user2_id" : chat.person.driver_id,
                                       "id" : chat.session_id,
                                       "trip" : 0]
        socket?.emit("join", param3,"s")
        
    }
    

    
    func registerUser() {
        print("\(Date()) 🎯 connected")
        
        let param2 = ["username" : "RAMON",
                      "type" : "dispatch"]
        print( "\(Date()) 🎯 chatRoom: emit set user")
        socket?.emit("setUser", param2,"s");
        
    }
    
    func checkIfConnected(_ socket : SocketIOClient ) {
                let myhandler = socket.handlers
                print(myhandler)
                let socketConectionStatus = socket.status
                print("🎯 status socket : \(socketConectionStatus)")
                switch socketConectionStatus {
                  case SocketIOStatus.connected:
                      print("socket connected")
                  case SocketIOStatus.connecting:
                      print("socket connecting")
                  case SocketIOStatus.disconnected:
                      socket.connect()
                      print("🎯 Conected from disconnected")
                  case SocketIOStatus.notConnected:
                      print("🎯 Conected from not connected")
        
                      socket.connect()
                   
                  }
    }
    
    
    func sendMessage(msg : String , chat : Chat) {
        
        let driverid = chat.person.driver_id
        guard  chat.session_id > 0 else {
            print(" ✏️ chatRoom: SEND_MESSAGE : Session is Null")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" ✏️ Error the username internal")
            return
        }
        
        ApiChat.insertMessage(msg: msg, chat: chat) { sucess, error, result in
            if let error = error {
                print("Error \(error)")
                return
            }
            if result == nil {
                return
            }
//            let dateFormatterGet = DateFormatter()
//            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.000000"
//            let dateString =  String(dateFormatterGet.string(from: Date()))
            
            let param = [
                "id" : result?.messageID ?? 0,
                "type" : 1,
                "session_id" : chat.session_id ,
                "where": "WEB",
                "trip":  "0",
                "to_user": driverid,
                "user_send": username,
                "driver" : driverid,
                "user" : username,
                "message": msg,
                "content" : msg,
                "date": result?.createdAt ?? "",
                "UUID" : chat.messages.last?.id.uuidString ?? UUID().uuidString,
            ] as [String : Any]
            
            print("✏️ chatRoom: send the message \(param)")
            self.socket?.emit("chat", param, "DALE")
            let chat_data = Chata_data()
            chat_data.insertMessage(chat: chat)
        }
    }
    
    
    
}

 
