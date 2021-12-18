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
    
  
    @EnvironmentObject var vm: UserStateViewModel
    
    
    private var messagesView : some View {
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
                    
                    
                }                .listRowInsets(EdgeInsets())
                
            }
        }.listStyle(PlainListStyle())
            
               
                
                
            
         
    }
    
    
    var body: some View {
       
      
        NavigationView {
            
            ZStack {
                Color("Marine").ignoresSafeArea()
                
                VStack {
//                    customNavBar
                    
                    HStack {
                        
                        SearchBar(text: $query)
                    }.padding(.horizontal)
                    messagesView
                }
                .navigationBarTitle("Chats", displayMode: .inline)
                
            }.navigationBarColor(UIColor(named: "Marine"))
             
             
            .navigationBarItems(trailing : Button(action: {

                self.isNewChat =  true
            })  {
                Image(systemName: "square.and.pencil")
            }).sheet(isPresented: $isNewChat) {
                NewChatView(isNewChat: $isNewChat,chatNew: $chatNew, isOpenChat: $isOpenChat).environmentObject(viewmodel)
            }
            
           
            
        }
           
           .navigationBarHidden(true)
           
        
//           .navigationBarBackButtonHidden(true)
       
        .overlay(overlayView: NotificationView().environmentObject(viewmodel)
                  , show: $viewmodel.isNewMessage)
        .alert(isPresented: $viewmodel.message_error.isMessageError) {
            Alert(title: Text("Error"),
                  message: Text(viewmodel.message_error.messageErrorText),
                  
                  dismissButton: .default(Text("OK"),
                                          action: {
                if viewmodel.message_error.messageErrorText == "Credentials Not found" {
                    UserDefaults.standard.setLoggedIn(false)
                    vm.signOut()
                }
            }))
            
        }
        .onAppear {
           
            UITableView.appearance().backgroundColor = UIColor(named: "Marine")
           

            
            viewmodel.fetchUsers()
           
        }
    }
 
    private var customNavBar : some View {
        HStack(spacing: 16) {
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text("USERNAME")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
            Button {
//                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
    }

    
    
}

struct chatRoom_Previews: PreviewProvider {
    static var previews: some View {
        ChatRooms().preferredColorScheme(.dark)
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
