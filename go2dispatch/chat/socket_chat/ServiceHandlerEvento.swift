//
//  ServiceHandlerEvento.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/17/21.
//

import Foundation


extension Service {
    func join_room(chat : Chat) {
        
        guard let username = UserDefaults.standard.getUserData()?.user.username else {
            print("No have User name ")
            return
        }
        guard chat.session_id > 0 else {
            return
        }
        // disnectamos received message
        socket?.off("newIdMessage2")
        print("\(Service.logs_chat) off newIdMessage2 ")
        socket?.off("chat")
        print("\(Service.logs_chat) off chat")
        self.setChats()
        self.setOpenChat()
        
        let param  = [
                      "session_id" :  chat.session_id,
                      ]
        
        socket?.emit("openchatweb", param )
        
        let param3 : [String : Any] = ["user1_id" : username,
                                       "user2_id" : chat.person.driver_id,
                                       "id" : chat.session_id,
                                       "trip" : 0]
        socket?.emit("join", param3,"s")
        print("\(Service.logs_chat) join")
        
    }
    func outRooms(chat: Chat){
        socket?.emit("salir", chat.session_id)
        print("\(Service.logs_chat) emit salir")
        socket?.off("chat")
        socket?.off("openedchat")
        print("\(Service.logs_chat) off chat, openedchat")
        self.setOnMessageReceived()
        print("\(Service.logs_chat) set Registration")
    }
    
}
