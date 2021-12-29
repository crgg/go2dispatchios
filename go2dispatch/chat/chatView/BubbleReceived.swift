//
//  BubbleReceived.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/28/21.
//

import SwiftUI

struct BubbleReceived: View {
    
     
    let message: Message
    
    
    
    var body: some View {
        
        ChatBubble(direction: .left) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(message.userOwn).font(.caption)
                    .foregroundColor(.red)
              
                    Text(message.text)
                
                
                    Text(getHours(date: message.date))
                        .font(.caption2)
                       
                        
                       
                
                 
            }.padding(.all, 10)
                .foregroundColor(Color.black)
                .background( Color.black.opacity(0.2))
          
        }
    
    }
    
    func getHours(date : Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        let d =  dateFormatterPrint.string(from: date)
        return String(d)
        
    }
    
}

struct BubbleReceived_Previews: PreviewProvider {
    static var previews: some View {
        BubbleReceived(message: Chat.sampleChat[0].messages[0])
//            .frame(width: .infinity, height: 100)
//            .previewLayout(.sizeThatFits)
    }
}
