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
    @EnvironmentObject var viewModel : ChatsViewModel
    
    
    @StateObject var vm = ChatAllUserViewModel()
    
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Marine").ignoresSafeArea()
                VStack {
                    HStack {
                        SearchBar(text: $query)
                    }
                    List {
                        
                        ForEach (vm.getSortedFilteredChatsAllDrivers(query: query)) { chat in
                            //  HACK to hide the disclosure Arrow!
                            ZStack {
                                //
                                Button(action: {
                                    self.isNewChat =  false
                                    self.chatNew = chat.getChat()
                                    self.isOpenChat = true
                                }) {

                                    ChatRowAll(chat: chat.getChat())
                                }
                                
                 
                            }.listRowInsets(EdgeInsets())
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
            
        }
        .onAppear {
            print("Entramos a View New Chat")
//            viewmodel.fetchAllUsers()
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView(isNewChat: .constant(true), chatNew: .constant(Chat.sampleChat[0]), isOpenChat: .constant(false))
            .environmentObject(ChatsViewModel())
    }
}
