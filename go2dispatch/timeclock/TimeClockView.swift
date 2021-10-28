//
//  TimeClockView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/27/21.
//

import SwiftUI

struct TimeClockView: View {
    var body: some View {
        VStack(alignment: .leading, spacing : 15) {
             
                Text("00:00:00").font(.title)
                Button(action: {}, label: {Text("CLOCK IN").foregroundColor(Color.white)
                    
                })
                .padding(40)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.green)
                
                    .mask(Circle())
            HStack {
                Image("ic_location").resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .clipped()
                Text("Location").font(.caption)
            }
            Text("OverView")
                .frame(maxWidth : .infinity, alignment: .center)
                .font(.caption)
                Spacer()
            List {
                ForEach(0..<12) {
                    item in
                    Text("dale \(item)")
                }
            }
        }.padding(.horizontal, 20.0)
            .frame(maxWidth : .infinity)
    }
}

struct TimeClockView_Previews: PreviewProvider {
    static var previews: some View {
        TimeClockView()
    }
}
