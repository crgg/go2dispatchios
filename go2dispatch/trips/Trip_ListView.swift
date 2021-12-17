//
//  Trip_ListView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import SwiftUI

struct Trip_ListView: View {
    
        
    let trips = TripList.sampleTrips
    @StateObject var viewmodel = TripListViewModel()
    @State private var query = ""
    @State var isNewChat = false
    @State var isOpenChat =  false
//    @State var chatNew : Chat = Chat.sampleChat[0]
    @State var showOverlay : Bool  = false
    
    var body: some View {
        
        
        NavigationView {
            
            ZStack {
                Color("Marine").ignoresSafeArea()
                
                VStack {
                    HStack {
                        
                        SearchBar(text: $query)
                    }
                    List {
                        
                        ForEach (viewmodel.getSortedFiltered(query: query)) { trip in
                            //  HACK to hide the disclosure Arrow!
                            ZStack { 
                                VStack {
                                    Text("ddj")
                                }
                                
//                                ChatRow(chat: chat)
//
//                                NavigationLink(
//                                    destination: {
//                                        ChatView(chat: chat)
//                                            .environmentObject(viewmodel)
//                                    })
//                                {
//                                    EmptyView()
//                                }.buttonStyle(PlainButtonStyle())
//                                    .frame(width: 0)
//                                    .opacity(0)
                                
                                
                            }
                            .listRowInsets(EdgeInsets())
                            
                            
                        }
                    }.listStyle(PlainListStyle())
                    
            
                }
            }
            .navigationBarTitle("Trips")
            .navigationBarHidden(false)
            .navigationBarItems(trailing : Button(action: {
                
                self.isNewChat =  true
            })  {
                Image(systemName: "square.and.pencil")
            }).sheet(isPresented: $isNewChat) {
//                NewChatView(isNewChat: $isNewChat,chatNew: $chatNew, isOpenChat: $isOpenChat).environmentObject(viewmodel)
            }
            
            
            
        }
        .navigationBarTitle("") //this must be empty
           .navigationBarHidden(true)
           .navigationBarBackButtonHidden(true)
//        .overlay(overlayView: NotificationView().environmentObject(viewmodel)
//                 , show: $viewmodel.isNewMessage)
        .onAppear {
            
            UITableView.appearance().backgroundColor = UIColor(named: "Marine")
            print("Entramos a View")
            viewmodel.getTrips()
            //            self.showOverlay =  viewmodel.getIsNewMessage()
            
        }
    }
}


struct Trip_ListView_Previews: PreviewProvider {
    static var previews: some View {
        Trip_ListView()
    }
}
