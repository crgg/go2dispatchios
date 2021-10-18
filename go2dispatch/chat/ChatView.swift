//
//  ChatView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/30/21.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var viewModel : ChatsViewModel
    
    let chat : Chat
    
    @State private var text = ""
    
    @State private var messageIDToScroll: UUID?
    
   // @FocusState private var isFocused
    
    var body: some View {
        VStack (spacing : 0) {
            GeometryReader {
                reader in
                ScrollView {
                    ScrollViewReader {
                        scrollReader in
                        getMessagesView(viewWith: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: messageIDToScroll) { _ in
                                if let messageID =  messageIDToScroll {
                                    scrollTo(messageID: messageID, shouldAdmimate: true, scrollReader: scrollReader)
                                }
                            }
                            .onAppear {
                                if let messageID = chat.messages.last?.id {
                                    scrollTo(messageID: messageID, anchor: .bottom, shouldAdmimate: false  , scrollReader: scrollReader)
                                }
                            }
                    }
 
                }
            }
            .padding(.bottom, 5)
            
          toolbarView()
           
        }
        .padding(.top, 1)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: navBarLeadingBtn, trailing: navBarTralingBtn)
        .onAppear {
            viewModel.markAsUnread(false, chat: chat)
        }
        
    }
    
    var navBarLeadingBtn : some View {
        Button(action: {}) {
            HStack {
                Image(chat.person.imgString).resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(chat.person.name).bold()
            }
            .foregroundColor(.black)
        
        
        }
    }
    
    var navBarTralingBtn : some View {
        HStack {
             
            Button(action: {}) {
                Image(systemName: "video")
                
            }
            
           Button(action: {}) {
               Image(systemName: "phone")
               
           }
        }
    }
    
    func scrollTo(messageID : UUID, anchor : UnitPoint? = nil, shouldAdmimate : Bool, scrollReader : ScrollViewProxy) {
        
        DispatchQueue.main.async {
            withAnimation(shouldAdmimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    func toolbarView() -> some View {
        VStack {
            let height : CGFloat = 37
            HStack {
                TextField("Message....", text: $text)
                    
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                  
//                    .focused($isFocused) // 15.0
                    
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: height, height: height)
                        .background(
                            Circle().foregroundColor(text.isEmpty ? .gray : .blue))
                }
                .disabled(text.isEmpty)
            }
            .frame(height: height)
            
        }
        .padding(.vertical)
        .padding(.horizontal)
//        .background(.thickMaterial) // 15.0
//        .background(Color.blue)
        
    }
    func sendMessage() {
        if let message = viewModel.sendMessage(text, in: chat) {
            text = ""
            messageIDToScroll = message.id
        }
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
                                    .background(isReceived ? Color.black.opacity(0.2) : .green.opacity(0.9))
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
