//
//  Service.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/4/21.
//

import Foundation
import SocketIO

final class Service : ObservableObject {
    
//    , .forceWebsockets(true),
//    , .forceNew(true), .forceWebsockets(true), .forcePolling(false)
    private var manager = SocketManager(socketURL: URL(string: "https://gotochat.tech4tms.com")!,
                                        config: [.log(true), .compress,
                                                 .extraHeaders(["Authorization":"VhCxBC3c1a9jSmoJAdhtvGj6lBtKfPGoXVGSTCMoYOzeEAkchbzjmvHxBQx6"])])
    @Published var messages = [String]()
    @Published var online = [String]()
    @Published var isNewMessage = false
    @Published var message_txt = false
    
    var socket: SocketIOClient?
    
    init() {
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) {  (data, ack) in
            
            print("🎯 conneted")
            self.registerUser()
                 
        }
        
        socket?.on("getUsersConnected") { data , ack in
            print("\(Date()) 🎯 get user rcl")
            
            if let datareceived = data as? [[String: Any]] {
                
                if  let data2 = datareceived[0]["clientsDriver"] as? [[String : Any]] {
//                            print("🎯 DISPATCHS-CHAT : getUsersConnected \(data2)")
                    for i in 0 ..< data2.count {
                        if let us = data2[i]["username"] as? String {
                         
                           
                                print("\(Date()) 🎯 is online \(us)")
                           
                        }
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
        
        socket?.on("newIdMessage") {  data , ack in
            
            if let dict  = data[0] as? [String : Any] {
                if let user = dict["user"] as? String {
                    if let message = dict["message"]  as? String {
                        
                       print("🇨🇱 user \(user) Message \(message)")
                        self.isNewMessage =  true

                    }
                }
            }

        }
        
        
        socket?.on(clientEvent: .disconnect) {  data , ack in
            print("🎯 socket discount")
            
        }
        
        

        
        //if !socket.status.active {
        socket?.connect()
      // }
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
    
}

