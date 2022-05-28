//
//  ChatRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/29/21.
//

import SwiftUI

extension String {
    
    func load() -> UIImage {
        do {
            guard let url = URL(string: self) else {
                return UIImage()
            }
            let data : Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            //
        }
        return UIImage()
    }
}

struct ChatRow: View {
    let chat: Chat
    @EnvironmentObject var viewModel : ChatsViewModel
    
    var body: some View {
        
        ZStack {
            Color("Marine") 
            HStack(spacing : 5) {
                ZStack {
                    DownloadingImageView(url: chat.person.imgString, key: chat.person.driver_id)
                        .frame(width: 70, height: 70)
//                                    Image(uiImage: chat.person.imgString.load()).resizable()
//                                        .frame(width: 70, height: 70)
//                                        .clipShape(Circle())
                                    
//                    Image(chat.person.imgString)
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .clipShape(Circle())
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
                    
                    if chat.hasUnreadMessage {
                        let d = ChatDataManager.instance.getMessageNoRead(session_id: chat.session_id)
                        ZStack {
                            Circle()
                                .fill(.blue)
                            Text(String(d.1))
                                .foregroundColor(.white)
                                .font(.caption)
                            
                        }
                        .frame(width: 25, height: 25)
                        .frame(maxWidth:.infinity, alignment: .trailing)
                    }
//                    Circle()
//                        .foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
//                        .frame(width: 18, height: 18)
//
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
                 msg = "🖼 Photo"
            case .video:
                 msg = "Video"
            
            }
        }
        return msg
    }
    
   
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat : Chat.sampleChat[1])
    }
}
