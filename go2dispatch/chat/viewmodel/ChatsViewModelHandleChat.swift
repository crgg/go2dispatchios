//
//  ChatsViewModelHandleChat.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/17/21.
//

import Foundation
extension ChatsViewModel {
    func joinRoom(chat : Chat) {
        DispatchQueue.main.async {
            self.messages = []
           
        }
        service.inTheRoom = true
        service.join_room(chat: chat)
        
        
    }
    
    func outRoom(chat: Chat) {
        service.inTheRoom = false
        service.outRooms(chat: chat)
    }
    
}
