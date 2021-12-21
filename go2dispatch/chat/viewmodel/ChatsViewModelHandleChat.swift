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
        
        service.join_room(chat: chat)
        
        
    }
    
    func outRoom(chat: Chat) {
        service.outRooms(chat: chat)
    }
    
}
