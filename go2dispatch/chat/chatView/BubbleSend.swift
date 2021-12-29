//
//  BubbleSend.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/28/21.
//

import SwiftUI

struct BubbleSend: View {
    let message: Message
    
    var body: some View {
        ChatBubble(direction: .right) {
            VStack (alignment: .trailing, spacing: 5){
               
                Text(message.text)
                   
                Text(getHours(date: message.date))
                    .font(.caption2)
                    .frame(alignment: .trailing)
                    .foregroundColor(.black)
                    .frame( alignment: .trailing)
                
                
                 
            }.padding(.all, 10)
                .foregroundColor(Color.black)
                .background(message.readed ? Color.green.opacity(0.8) : Color.blue)
        }
    }
    
    func getHours(date : Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        let d =  dateFormatterPrint.string(from: date)
        return String(d)
        
    }
 }


struct BubbleSend_Previews: PreviewProvider {
    static var previews: some View {
        BubbleSend(message: Chat.sampleChat[0].messages[0])
    }
}
