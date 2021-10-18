//
//  NewChatView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/8/21.
//

import SwiftUI

struct NewChatView: View {
    
    let chats = Chat.sampleChat
    
    @Binding var isNewChat : Bool
    @Binding var chatNew : Chat
    @Binding var isOpenChat : Bool
    
    @EnvironmentObject var viewmodel : ChatsViewModel
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $query)
                }
                List {
                    
                    ForEach (viewmodel.getSortedFilteredChatsAllDrivers(query: query)) { chat in
                        //  HACK to hide the disclosure Arrow!
                        ZStack {
//
                            Button(action: {
                                self.isNewChat =  false
                                self.isOpenChat = true
                                self.chatNew = chat
                            }) {
                                ChatRow(chat: chat)
                            }
                            
                           
                            
                            
//                            NavigationLink(
//                                destination:
//                                    ChatView(chat: chat).environmentObject(viewmodel)
//                                 , isActive: $isOpenChat)
//                            {
//                                EmptyView()
//                            }.buttonStyle(PlainButtonStyle())
//                                .frame(width: 0)
//                                .opacity(0)
                        }
                    }
                }.listStyle(PlainListStyle())
            }
            .navigationTitle("New Chat")
            .navigationBarItems(trailing : Button(action: {
                self.isNewChat = false
                
            })  {
               Text("Cancel")
            })
        }
        .onAppear {
            print("Entramos a View New Chat")
            viewmodel.fetchAllUsers()
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView(isNewChat: .constant(true), chatNew: .constant(Chat.sampleChat[0]), isOpenChat: .constant(false))
            .environmentObject(ChatsViewModel())
    }
}
