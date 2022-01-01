//
//  ChatHeader.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/29/21.
//

import SwiftUI

struct ChatHeader: View {
    let message : Message
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.blue.opacity(0.5))
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundColor(.black)
                .padding(10)
                .font(.system(size: 12,weight: .regular))
                
               
                 
                
//                .background(Capsule().foregroundColor(.blue))
            
//
        }.padding(2)
            .fixedSize()
         
        
    }
}

struct ChatHeader_Previews: PreviewProvider {
    static var previews: some View {
        ChatHeader(message: Chat.sampleChat[0].messages[0])
            .frame( height: 30)
            .previewLayout(.sizeThatFits)
    }
}
