//
//  BubleImage.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/28/21.
//

import SwiftUI

struct BubleImage: View {
    let message: Message
    @StateObject var loader : ImageLoadingViewModel
    init(message : Message, url: String, key : String) {
        self.message = message
        
        if message.messageId == 0 {
            print("🤳 no message id o digame \(message.id.uuidString)")
            _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: message.id.uuidString))
            
        } else {
            _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: url, key: key))
        }
        
        
    }
    var body: some View {
        ChatBubble(direction:  message.type == .received ? .left : .right) {
            VStack{
                if message.type == .received {
                    Text(message.userOwn).font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                        .padding(.top,5)
                }
                
                if loader.isLoading {
                    ProgressView()
                } else if let image = loader.image {
                 Image(uiImage: image)
                                      .resizable()
                                      .frame(width: UIScreen.main.bounds.width - 70,
                                             height: 200).aspectRatio(contentMode: .fill)
                }
                Text(getHours(date: message.date))
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.black)
                    .padding(.horizontal,10)
                 
            }.padding(.all, 8)
                .foregroundColor(Color.black)
                .background(message.type == .received ? Color.black.opacity(0.2) :  message.readed ? Color.green.opacity(0.8) : Color.blue)
        }
    }


func getHours(date : Date) -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "hh:mm a"
    let d =  dateFormatterPrint.string(from: date)
    return String(d)
    
}
    
}

struct BubleImage_Previews: PreviewProvider {
    static var previews: some View {
        BubleImage(message: Chat.sampleChat[0].messages[0], url: "https://media.goto-logistics.com/TruckmateDownload/TRAILERS/122021/53309_61cbc7cf8ee4e.jpg", key:  "1")
    }
}
