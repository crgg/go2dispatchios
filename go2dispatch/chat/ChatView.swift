//
//  ChatView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/30/21.
//

import SwiftUI
import UIKit

struct ChatView: View {
    
    @EnvironmentObject var viewModel : ChatsViewModel
 

    @State private var isCameraActive = false
    
    
    let chat : Chat
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var text = ""
    
    @State private var messageIDToScroll: UUID?
    
   // @FocusState private var isFocused
    
    var body: some View {
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
                                .padding(.horizontal)
                                .onChange(of: viewModel.messageIDToScroll) { _ in
                      
                                    if let messageID =  viewModel.messageIDToScroll {
                                        scrollTo(messageID: messageID, shouldAdmimate: false, scrollReader: scrollReader)
                                    }
                                }
                                .onAppear {
                                    
                                    
//                                    if let messageID = viewModel.messages.last?.id {
//                                        messageIDToScroll = messageID
//                                        scrollTo(messageID: messageID, anchor: .bottom, shouldAdmimate: false  , scrollReader: scrollReader)
//                                    }
                                }
                        }
     
                    }
                }
                .padding(.bottom, 5)
                .background(Color.white)
                
              toolbarView()
               
            }
            .padding(.top, 1)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: navBarLeadingBtn)
            .background(NavigationConfigurator { nc in
                           nc.navigationBar.barTintColor = .blue

                nc.toolbar.tintColor = .blue
                nc.navigationBar.backItem?.titleView?.tintColor = .blue
                           nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                       })
            . navigationBarColor(UIColor(named: "Marine"))
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                viewModel.markAsUnread(false, chat: chat)
    //            viewModel.service.set_header(driverId: chat.person.driver_id, session_id: chat.session_id)
                viewModel.joinRoom(chat:  chat)
                viewModel.setCurrentChat(chat: chat)
                viewModel.getMessages(session_id: chat.session_id)
                let appearance = UINavigationBarAppearance()
                       appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                       appearance.backgroundColor = UIColor(Color.orange.opacity(0.2))
                       
            }
            .onDisappear {
                
            }

            
        }
                
    }
    
    var navBarLeadingBtn : some View {
         
            HStack {
                Button(action : {
                    viewModel.outRoom(chat: chat)
                    self.presentationMode.wrappedValue.dismiss()                }) {
                    Image(systemName: "arrow.left.circle")
                }
                
                
                Image(uiImage: chat.person.imgString.load()).resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(viewModel.isTyping ? "Typing" : chat.person.name).bold()
                
            }
            .foregroundColor(.white)
        
    }
    
    
//    var navBarTralingBtn : some View {
//        HStack {
//            Button(action: {}) {
//                Image(systemName: "trash.circle.fill")
//            }
//        }
//    }
//
    func scrollTo(messageID : UUID, anchor : UnitPoint? = nil, shouldAdmimate : Bool, scrollReader : ScrollViewProxy) {
        
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
                               CameraViewController()

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
       
        
       
//        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//            .background(Color.white)

        
//        .padding(.horizontal)
//        .background(.thickMaterial) // 15.0
//        .background(Color.blue)
        
    }
    
    struct RoundedShape : Shape {
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
            return Path(path.cgPath)
        }
    }
    
    func sendMessage() {
        
          let message = viewModel.sendMessage2(text, chat: chat)
           text  = ""
             
//             messageIDToScroll = message.id
           viewModel.messageIDToScroll  = message.id
        
        
//        if let message = viewModel.sendMessage(text, in: chat) {
//            text = ""
//            messageIDToScroll = message.id
//        }
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    func getMessagesView(viewWith: CGFloat) -> some View  {
        
        
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            let sectionMessage = viewModel.getSectionMessage(for: chat)
            ForEach(sectionMessage.indices, id: \.self) { sectionIndex in
                let messages = sectionMessage[sectionIndex]
                if messages.count > 0 {
                    Section(header: sectionHeader(firstMessage: messages.first!)) {
                        ForEach(messages) { message in
                            let isReceived = message.type == .received
                            
                            HStack {
                                ZStack {
                                    Text(message.text)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                        .background(isReceived ? Color.black.opacity(0.2) : message.readed  ? .green.opacity(0.9) : .blue.opacity(0.9))
                                        .cornerRadius(13)
                                }
                                .frame(width : viewWith * 0.7, alignment: isReceived ? .leading : .trailing)
                                .padding(.vertical)
                                //                    .background(Color.blue)
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
        ZStack {
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundColor(.white)
                .font(.system(size: 14,weight: .regular))
                .frame(width: 120)
                .padding(.vertical, 5)
                .background(Color.blue)
                .background(Capsule().foregroundColor(.blue))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            
            ChatView(chat: Chat.sampleChat[0])
                .environmentObject(ChatsViewModel())
        }
    }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

 
struct CameraViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> UIViewController {
        let camevc =  CameraCaptureViewController()
        return camevc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
        //
    }
    
    
    typealias UIViewControllerType = UIViewController
    
    
}

 
