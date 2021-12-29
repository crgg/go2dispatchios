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
    func allOffOnline()
    func newMessageChat(m : Message, user_send : String)
    func typing(session_id : Int , username : String)
    func readMessageUUID(uuid : String)
    func readMessageIdSessionId(message_id : Int , session_id : Int)
    func openChat(openChatData : ParseDatosOfSocket.OpenChatDataReceived)
    func newSession(session_id : Int)
}

final class Service : ObservableObject {
    
//    , .forceWebsockets(true),
//    , .forceNew(true), .forceWebsockets(true), .forcePolling(false)
    private var manager = SocketManager(socketURL: URL(string: ApiConfig.URL_CHAT)!,
                                        config: [.log(true), .compress,
                                                 .extraHeaders(["Authorization":"VhCxBC3c1a9jSmoJAdhtvGj6lBtKfPGoXVGSTCMoYOzeEAkchbzjmvHxBQx6"])])
    @Published var messages = [String]()
    @Published var online = [String]()
    @Published var isNewMessage = false
    @Published var message_txt = false
    @Published var currenChat : Chat = Chat.sampleChat[0]
    
   var callback : ServiceChatProtocol?
    
    static let logs_chat : String = "🎯 \(Date())"
  
    
    var socket: SocketIOClient?
    
    init() {
        callback = nil
        
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) {  (data, ack) in
            print("\(Service.logs_chat) connected socket")
            
            self.socket?.emit("check_user_online")
            print("\(Service.logs_chat) emit check_user_online")
            
            
            self.registerUser()
                 
        }
        
        // get all users Conencted
        socket?.on("getUsersConnected") { data , ack in
            print("\(Service.logs_chat) get user rcl")
            if let datareceived = data as? [[String: Any]] {
                if  let data2 = datareceived[0]["clientsDriver"] as? [[String : Any]] {
                    guard data2.count > 0 else {
                        self.callback?.allOffOnline()
                        
                        return
                    }
                    
                    ParseDatosOfSocket.parseUsersOnline(data2: data2) {
                        (list_online) in
                        self.callback?.listOnline(list_online: list_online)
                    }
                }
            }
        }
        
        // Event the errors
        socket?.on(clientEvent: .error) { data, ack in
            print("\(Service.logs_chat) Error socket")
            if let errorStr: String = (data[0] as? String) {
                if errorStr.hasPrefix("ERR_SOCKETIO_INVALID_SESSION") {
                    self.socket?.disconnect()
                    print("\(Service.logs_chat) App Chat: error \(errorStr)")
                     return
                }
                    
                 if errorStr == "Tried emitting when not connected" {
                     print("\(Service.logs_chat) \(errorStr)")
                     return
                 }
              }
            self.socket?.disconnect()
            self.socket?.connect()
            
        }
        
        // set received the event ("chat")
        self.setChats()
        
        // set Message Received
        self.setOnMessageReceived()
        
        
        // event the sockect discount
        socket?.on(clientEvent: .disconnect) {  data , ack in
            print("\(Service.logs_chat) socket discount")
            self.socket?.connect()
        }
        
        // event adavance the user open the session
   
        socket?.on("new_session") { data , ack in
            print("\(Service.logs_chat) create a nuevo session")
        }
        socket?.on("typing") {
              data, ack in
            if let result  = data[0] as? [String : Any] {
//                g ["session_id": 274, "user": RAMON, "from": PHONE]
                print("\(Service.logs_chat) typing \(result)")
                if let session_id = result["session_id"] as? Int, let user = result["user"] as? String {
                    
                    self.callback?.typing(session_id: session_id, username: user)
                }
                
                
                
                
            }
            
        }
        socket?.on("chat_pend") { data, ack in
            print("\(Service.logs_chat) chat_pend")
        }
        
        socket?.on("no-read") {
            data , ack in
            print("\(Service.logs_chat) no-read")
        }
        socket?.on("openedchatwebforphone") { data, ack in
            print("\(Service.logs_chat) openedfromwebsite")
        }
        
        socket?.on("messages") { data, ack in
                print("\(Service.logs_chat) message")
      }
            
       
        
        socket?.on("sever_error") {
            data, ack in
            print("\(Service.logs_chat) sever error")
            
        }
        
        socket?.on("readMessage") { data, ack in
            if let datarc = data[0] as? [String : Any] {
                if let uuid = datarc["uuid"] as? String {
                    print(uuid)
                    self.callback?.readMessageUUID(uuid: uuid)
                    
                }
                if let message_id =  datarc["message_id"] as? Int ,
                   let session_id = datarc["session_id"] as? Int{
                    self.callback?.readMessageIdSessionId(message_id: message_id, session_id: session_id)
                    
                }
            }
           print(" \(Service.logs_chat) read the message")
        }
        

        
        //if !socket.status.active {
        socket?.connect()
        
     
        
        
        
      // }
    }
    func setOpenChat() {
        print("\(Service.logs_chat) set openedchat")
        socket?.on("openedchat") {
            data, ack in
            print("\(Service.logs_chat) socket openedchat")
            ParseDatosOfSocket.parserOpenChat(dataReceived: data[0]) { r_result in
                if let result = r_result {
                    self.callback?.openChat(openChatData: result)
                    
                }
            }
            
        }
    }
    
    func setChats() {
        socket?.on("chat") { data, ack in
            
            print("\(Service.logs_chat) event chat")
            
            if let dict  = data[0] as? [String : Any] {
                
                if let userSend = dict["user_send"] as? String  {
                    if let curent_user =  UserDefaults.standard.getUserData()?.user.username  {
                        if curent_user == userSend {
                            return
                        }
                    }
                }
                
              print("\(Service.logs_chat) received \(dict["message"] ?? "none")")
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
                    
                    
                    var m = Message(result.message ?? "", type: contentType, date: UtilDate.parseDate(dateString: result.date!)!   , content_type: ctype, userOwn: result.user_send ?? "", messageId: result.id ?? 0)
                    m.readed = false
                    
                    self.currenChat.messages[0] = m
                    
                    ChatDataManager.instance.insertMessage(chat: self.currenChat)
                    self.callback?.newMessageChat(m: m, user_send: result.user_send ?? "")
                    
                    
                    
                    let paramav : [String : Any] = ["session_id" : result.session_id ?? 0,
                                                    "message" : result.message ?? "",
                                                    "user" : result.user_send ,
                                                    "wherefrom" : "WEB",
                                                    "uuid" : result.uuid.uuidString,
                                                    "message_id" : self.currenChat.session_id]
                                               
                    self.socket?.emit("read_message", paramav)
                    print("\(Service.logs_chat) emit read_message")
                 
                }
                
            }
        }
    }
    
    func setOnMessageReceived() {
        socket?.on("newIdMessage2") {  data , ack in
            print("\(Service.logs_chat) new Id Message")
            if let dict = data[0] as? [String: Any] {
              let newMessage =   New_messag_received(dict)
                self.callback?.newMessage(newMessageReceived: newMessage)
                
            }
        }
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
        print( "\(Service.logs_chat) chatRoom: emit set-header \(param)")
       
        socket?.emit("set-header", param,"s")
        print("\(Service.logs_chat) emit set-header")
    }
    
  
    

    
    func registerUser() {
        let param2 = ["username" : "RAMON",
                      "type" : "dispatch"]
        print( "\(Service.logs_chat) chatRoom: emit set user")
        socket?.emit("setUser", param2,"s");
        print("\(Service.logs_chat) emit setUser")
        
    }
    
    func checkIfConnected(_ socket : SocketIOClient ) {
                let myhandler = socket.handlers
                print(myhandler)
                let socketConectionStatus = socket.status
                print("\(Service.logs_chat) status socket : \(socketConectionStatus)")
                switch socketConectionStatus {
                  case SocketIOStatus.connected:
                      print("\(Service.logs_chat) socket connected")
                  case SocketIOStatus.connecting:
                      print("\(Service.logs_chat) socket connecting")
                  case SocketIOStatus.disconnected:
                      socket.connect()
                      print("\(Service.logs_chat) Conected from disconnected")
                  case SocketIOStatus.notConnected:
                      print("\(Service.logs_chat) Conected from not connected")
        
                      socket.connect()
                   
                  }
    }
    
    
    func sendMessage(msg : String , chat : Chat, uuid : UUID) {
        
        let driverid = chat.person.driver_id
        guard  chat.session_id > 0 else {
            print(" \(Service.logs_chat) chatRoom: SEND_MESSAGE : Session is Null")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" \(Service.logs_chat) Error the username internal")
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
                "UUID" : uuid.uuidString,
            ] as [String : Any]
            
            print("\(Service.logs_chat) chatRoom: send the message \(param)")
            self.socket?.emit("chat", param, "DALE")
            print("\(Service.logs_chat) emit Chat")
            
            ChatDataManager.instance.insertMessage(chat: chat)
        }
    }
    
    
    
}

 
