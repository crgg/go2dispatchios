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
    @State var showOverlay : Bool  = false
    
    init(){
            UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.white)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.white)]
        }
    
    
    var body: some View {
       
      
        NavigationView {
            
            ZStack {
                Color("Marine").ignoresSafeArea()
                    
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
                            .listRowInsets(EdgeInsets())
                                
                                
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
            }
            .navigationBarTitle("Chats")
            .navigationBarHidden(false)
            .navigationBarItems(trailing : Button(action: {
                
                self.isNewChat =  true
            })  {
                Image(systemName: "square.and.pencil")
            }).sheet(isPresented: $isNewChat) {
                NewChatView(isNewChat: $isNewChat,chatNew: $chatNew, isOpenChat: $isOpenChat).environmentObject(viewmodel)
            }.overlay(overlayView: Banner.init(data: Banner.BannerDataModel(title: "Title", detail: "your message", type: .success), show: $showOverlay)
                      , show: $showOverlay)
            
        }
        .onAppear {
           
            UITableView.appearance().backgroundColor = UIColor(named: "Marine")
            print("Entramos a View")
            viewmodel.fetchUsers()
//            self.showOverlay =  viewmodel.getIsNewMessage()
           
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
