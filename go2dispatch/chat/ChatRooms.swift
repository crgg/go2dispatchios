//
//  chatRoom.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import SwiftUI
import SocketIO

struct ChatRooms: View {
    
    let chats = Chat.sampleChat
    @StateObject var viewmodel = ChatsViewModel()
    @State private var query = ""
    @State var isNewChat = false
    @State var isOpenChat =  false
    @State var chatNew : Chat = Chat.sampleChat[0]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $query)
                }
                List {
                    
                    ForEach (viewmodel.getSortedFilteredChats(query: query)) { chat in
                        //  HACK to hide the disclosure Arrow!
                        ZStack {
                            ChatRow(chat: chat)
                            NavigationLink(
                                destination: {
                                    ChatView(chat: chat)
                                        .environmentObject(viewmodel)
                                })
                            {
                                EmptyView()
                            }.buttonStyle(PlainButtonStyle())
                                .frame(width: 0)
                                .opacity(0)
                            
                        }
                    }
                }.listStyle(PlainListStyle())
                NavigationLink(destination:
                       
                            ChatView(chat:  self.chatNew)
                                .environmentObject(viewmodel)
                        
                     , isActive: $isOpenChat)
                {
                     
                    EmptyView()
                }.buttonStyle(PlainButtonStyle())
                    .frame(width: 0)
                    .opacity(0)
            }
            
            .navigationTitle("Chats")
            .navigationBarItems(trailing : Button(action: {
                self.isNewChat =  true
            })  {
                Image(systemName: "square.and.pencil")
            }).sheet(isPresented: $isNewChat) {
                NewChatView(isNewChat: $isNewChat,chatNew: $chatNew, isOpenChat: $isOpenChat).environmentObject(viewmodel)
            }
            
         
               
             
            
        }
        .onAppear {
            print("Entramos a View")
            viewmodel.fetchUsers()
           
        }
    }
}

struct chatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRooms()

    }
}
//                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                            Button (action: {
//                                viewmodel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
//                            }){
//                                if chat.hasUnreadMessage {
//                                    Label("Read", systemImage: "text.bubble")
//                                } else {
//                                    Label("Unread", systemImage: "circle.fill")
//                                }
//                            }
//
//                        }.tint(.blue)
