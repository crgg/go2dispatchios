//
//  ChatViewModal.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/27/21.
//

import SwiftUI

struct ChatViewModal: View {
    @EnvironmentObject var viewModel : ChatsViewModel
 
    @State private var isCameraActive = false
    
    let chat : Chat
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var text = ""
    
    @State private var messageIDToScroll: UUID?
    
    @State  private var ScaleXleft = false
    @State  private var ScaleYleft = false
    @State  private var ScaleXright = false
    @State  private var ScaleYright = false
    @State  private var ScaleXmiddle = false
    @State  private var ScaleYmiddle = false
    
    
    
    var body: some View {
        ZStack {
            VStack {
                customNavBar
                Spacer()
                ZStack {
                    Color.blue
                                .opacity(0.4)
                                .ignoresSafeArea()
                    VStack (spacing : 0) {
                        GeometryReader {
                            reader in
                            ScrollView {
                                ScrollViewReader {
                                    scrollReader in
                                     
                                    
                                    getMessagesView(viewWith: reader.size.width)
                                        .padding(.horizontal,0)
                                        .onChange(of: viewModel.messageIDToScroll) { _ in

                                            if let messageID =  viewModel.messageIDToScroll {
                                                scrollTo(messageID: messageID, shouldAdmimate: false, scrollReader: scrollReader)
                                            }
                                        }
//                                    HStack{ Spacer() }
//                                    .id("Empty")
//                                    .onReceive(viewModel.$count) { _  in
//
//                                        withAnimation(.easeOut(duration: 0.5)) {
//                                            scrollReader.scrollTo("Empty", anchor: .bottom)
//                                        }
//
//                                    }
                                }
             
                            }
                        }
                        .padding(.bottom, 5)
                        .background(Color.white)
                        
                      toolbarView()
                       
                    }
                    .padding(.top, 1)
                    .onAppear {
                        viewModel.markAsUnread(false, chat: chat)
            //            viewModel.service.set_header(driverId: chat.person.driver_id, session_id: chat.session_id)
                        viewModel.joinRoom(chat:  chat)
                        viewModel.setCurrentChat(chat: chat)
                        viewModel.getMessages(session_id: chat.session_id)
//                        let appearance = UINavigationBarAppearance()
//                               appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
////                               appearance.backgroundColor = UIColor(Color.orange.opacity(0.2))
                               
                    }
                    .onDisappear {
                        
                    }

                    
                }
            }
        }
    }
    
    
    
    private var customNavBar: some View {
        HStack() {
            Button(action : {
                viewModel.outRoom(chat: chat)
                self.presentationMode.wrappedValue.dismiss()                }) {
                Image(systemName: "arrow.left.circle")
           
            }
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                   
                    DownloadingImageView(url: chat.person.imgString, key: chat.person.driver_id)
                        .frame(width: 40, height: 40)
                    VStack (alignment : .leading, spacing: 3 ) {
                        Text(chat.person.name)
                            .font(.system(size: 14, weight: .bold))
                        HStack( spacing: 2) {
                            
                         
                            if !viewModel.isTyping {
                                Circle()
                                    .foregroundColor(chat.online ? .green : .black)
                                    .frame(width: 14, height: 14)
                                Text(viewModel.getElCurrentChat().online ? "online" : "inactive")
                                    .font(.system(size: 12))
                                  .foregroundColor(Color(.lightGray))
                            } else {
                      
                                typingView()
                                Text(viewModel.isTyping ? "Typing..." : "").foregroundColor(.gray)
                            }
                            
                            
                        }
                        
                    }.padding(0)
                    Spacer()
                 
                    Button {
                        //
                    } label: {
                        Image(systemName: "mappin")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(.label))
                    }

                }
             
                
                
            }
           
      
        }.padding(.horizontal)
         
     
    }
   
    func scrollTo(messageID : UUID, anchor : UnitPoint? = nil, shouldAdmimate : Bool, scrollReader : ScrollViewProxy) {
        print("uuid last \(messageID)")
        DispatchQueue.main.async {
            withAnimation(shouldAdmimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    
    
    func toolbarView() -> some View {
        VStack {
           
          
            
            HStack(spacing: 15) {
                HStack(spacing : 15) {
                    TextField("Message....", text: $text)
                    
                    //                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    
                    //                    .focused($isFocused) // 15.0
                    Button(action: {
                        isCameraActive = true
                    }) {
                        Image(systemName: "paperclip.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .sheet(isPresented: $isCameraActive, content: {
                                CameraViewController(chat: chat, vm: viewModel)
                            })
                        
                    }
                    
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.black.opacity(0.06))
                .clipShape(Capsule())
                    
                if text != "" {
                    // Send button
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color.blue)
                        //rotation the image
                            .rotationEffect(.init(degrees: 45))
                            .padding(.vertical, 12)
                            .padding(.leading, 12)
                            .padding(.trailing, 17)
                            .background(Color.black.opacity(0.07))
                            .clipShape(Circle())
                    }
                    .disabled(text.isEmpty)
                }
                

            }.padding(.horizontal)
                .animation(.easeOut)
               
                
        }
        .padding(.bottom, 8)
        .background(Color.white)
       
        
        
        
    }
    struct RoundedShape : Shape {
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
            return Path(path.cgPath)
        }
    }
    
    func sendMessage() {
        
        guard !text.isEmpty else {
            return
        }
        
    viewModel.sendMessage2(text, chat: chat) {
             status, result in
            if status {
                if let result = result {
                    
                    DispatchQueue.main.async {
                        self.viewModel.messageIDToScroll  = result.id
                    }
                }
            }
                
            
          }
        self.text  = ""
        
        
//        if let message = viewModel.sendMessage(text, in: chat) {
//            text = ""
//            messageIDToScroll = message.id
//        }
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    
    
    
    func getMessagesView(viewWith: CGFloat) -> some View  {
 
//            ForEach(viewModel.messages) { m in
//                let isReceived = m.messageParse.type == .received
//                HStack {
//                    ZStack {
//                        if m.messageParse.content_type == .text {
//                            Text(m.messageParse.text)
//                                .padding(.horizontal)
//                                .padding(.vertical, 12)
//                                .background(isReceived ? Color.black.opacity(0.2) : m.messageParse.readed  ? .green.opacity(0.9) : .blue.opacity(0.9))
//                                .cornerRadius(13)
//                        } else {
//                            DownloadingImageView(url: m.messageParse.text, key: String(m.id))
//                                .frame(width: 150, height: 150)
//                        }
//                    }.frame(width : viewWith * 0.7, alignment: isReceived ? .leading : .trailing)
//
//                    //                                    .padding(.vertical)
//                }.frame(maxWidth: .infinity,  alignment:  isReceived ? .leading : .trailing)
//            }
//
        
     
//
        
        
        
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            let sectionMessage = viewModel.getSectionMessage(for: chat)


            ForEach(sectionMessage.indices, id: \.self) { sectionIndex in
                let messages = sectionMessage[sectionIndex]
                if messages.count > 0 {
                    Section(header: sectionHeader(firstMessage: messages.first!)) {
                        ForEach(messages) { message in
                            let isReceived = message.type == .received
                            let typMsg = message.content_type
                                HStack {

                                    ZStack {
                                        if  typMsg == .text {
                                            
                                            if isReceived {
                                                BubbleReceived(message: message )
                                            } else {
                                                BubbleSend(message: message)
                                            }
 
                                        } else {
                                           
                                            BubleImage(message: message, url: message.text, key: String(message.messageId))
                                            
                                        }



                                    }.frame(  alignment: isReceived ? .leading : .trailing)
                                        .padding(.vertical,0)


                                }
                                .frame(maxWidth: .infinity,  alignment:  isReceived ? .leading : .trailing)
                                

                                .id(message.id) // important for automatic scrolling later!


                        }

                    }
                }
            }
        }
    }
    
   
        
    func sectionHeader(firstMessage message: Message) -> some View {
        ChatHeader(message: message)
        
    }
    
    func typingView() -> some View {
        HStack {
        ZStack {
            Circle()
                .frame(width: 15, height: 15)
                .opacity(0.5)
          Circle()
            .frame(width: 15, height: 15)
            .foregroundColor(.blue)
            .opacity(0.5)
                .scaleEffect(x: ScaleXleft ? 1 : 0.7, y: ScaleYleft ? 1 : 0.3, anchor : .bottom)
                .animation(Animation.easeOut(duration: 0.3).repeatCount(150, autoreverses: true))
                .onAppear() {
                    self.ScaleYleft.toggle()
                    self.ScaleYleft.toggle()
                }
        }
            // middle
        ZStack {
            Circle()
                .frame(width: 15, height: 15)
                .opacity(0.5)
          Circle()
            .frame(width: 15, height: 15)
            .foregroundColor(.blue)
            .opacity(0.5)
                .scaleEffect(x: ScaleXmiddle ? 1 : 0.7, y: ScaleYmiddle ? 1 : 0.3, anchor : .bottom)
                .animation(Animation.easeOut(duration: 0.3).repeatCount(150, autoreverses: true).delay(0.2))
                .onAppear() {
                    self.ScaleYmiddle.toggle()
                    self.ScaleYmiddle.toggle()
                }
        }
        
        // right
        ZStack {
            Circle()
                .frame(width: 15, height: 15)
                .opacity(0.5)
          Circle()
            .frame(width: 15, height: 15)
            .foregroundColor(.blue)
            .opacity(0.5)
                .scaleEffect(x: ScaleXright ? 1 : 0.7, y: ScaleYright ? 1 : 0.3, anchor : .bottom)
                .animation(Animation.easeOut(duration: 0.3).repeatCount(150, autoreverses: true).delay(0.4))
                .onAppear() {
                    self.ScaleYright.toggle()
                    self.ScaleYright.toggle()
                }
        }
        }
    }
    
}

struct ChatViewModal_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewModal(chat: Chat.sampleChat[0])
                        .environmentObject(ChatsViewModel())
    }
}


