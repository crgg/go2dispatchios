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
    var body: some View {
        
        ZStack {
            Color("Marine") 
            HStack(spacing : 5) {
                Image(uiImage: chat.person.imgString.load()).resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
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
                            Text(chat.messages.last?.date.descriptiveString() ?? "")
                                .foregroundColor(.white)
                            
                        }
                        HStack {
                            Text(chat.messages.last?.text ?? "")
                                .foregroundColor(.gray)
                                .lineLimit(2)
                                .frame( height: 50, alignment: .top)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 40)
                        }
                        
                    }
                    Circle()
                        .foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
                        .frame(width: 18, height: 18)
                        .frame(maxWidth:.infinity, alignment: .trailing)
                }
            }
            .frame(height: 80)
            .padding(10)
            
        }
       
    }
    
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat : Chat.sampleChat[1])
    }
}
