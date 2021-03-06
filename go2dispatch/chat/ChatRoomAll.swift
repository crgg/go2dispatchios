//
//  ChatRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/29/21.
//

import SwiftUI


struct ChatRowAll: View {
    let chat: Chat
 
       
        var body: some View {
            
            ZStack {
                Color("Marine")
                HStack(spacing : 5) {
                    ZStack {
                        DownloadingImageView(url: chat.person.imgString, key: chat.person.driver_id)
                            .frame(width: 70, height: 70)
                        
 
                        ZStack {
                            Circle()
                                .fill(chat.online ? .green : .clear)
                                .frame(width: 10, height: 10 )
                                .frame(maxWidth:70, maxHeight: 70, alignment: .topLeading)
                                .padding(.top)
                            Circle()
                                .strokeBorder(chat.online ? .black : .clear)
                                .frame(width: 10, height: 10 )
                                .frame(maxWidth:70, maxHeight: 70, alignment: .topLeading)
                                .padding(.top)
                        }
                                  
                    }
                    ZStack {
                        
                        VStack(alignment : .leading, spacing: 5) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(chat.person.driver_id).bold()
                                        .foregroundColor(.white)
                                    Text(chat.person.name).font(.system(size:12))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                           
                                Text(    chat.messages.last?.date.descriptiveString() ?? "")
                                    .foregroundColor(.white)
                                
                              
                            
                                
                                
                            }
                            HStack {
                                                            
                                
    //                            __ = chat.messages.last?.type == .received ? "" :
    //                            "you "
                                
                                Text(self.getTypeContent(last_msg: chat.messages.last?.text ?? "", type_content: chat.messages.last?.content_type ?? .text ))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .frame( height: 50, alignment: .top)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing, 40)
                             
                                    
                            }
                            
                        }
//                        Circle()
//                            .foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
//                            .frame(width: 18, height: 18)
//                            .frame(maxWidth:.infinity, alignment: .trailing)
                    }
                }
                .frame(height: 80)
                .padding(10)
                
            }
           
        }
     
        func getTypeContent(last_msg : String, type_content : contentType) -> String{
            
            var msg = ""
       
            if  !last_msg.isEmpty {
                switch type_content {
                case .text :
                     msg = last_msg
                case .image :
                     msg = "???? Photo"
                case .video:
                     msg = "Video"
                
                }
            }
            return msg
        }
        
       
    }
 

struct ChatRowAll_Previews: PreviewProvider {
    static var previews: some View {
        ChatRowAll(chat: Chat.sampleChat[0])
    }
}

