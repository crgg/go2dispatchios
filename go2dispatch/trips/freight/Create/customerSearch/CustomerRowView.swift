//
//  CustomerRowView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/17/22.
//

import SwiftUI
import AVFoundation

struct CustomerRowView: View {
    let cust : CustomerModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(cust.NAME ?? "" )
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.title3.weight(.bold))
                    Spacer()
                    TextTripView(texto: cust.CLIENT_ID, colorFont: Color.theme.secondaryText)
                    
                    
                }
                TextTripView(texto: "\(cust.CITY ?? "") , \(cust.PROVINCE ?? "")", colorFont:
                                Color.theme.secondaryText)
                
//                Divider().background(Color.theme.secondaryText)
            }
            VStack(alignment: .trailing) {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.theme.secondaryText)
                
            }.padding(.horizontal,3)
        }.padding(10)
            .background(Color.theme.background)

        
    }
}

struct CustomerRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomerRowView(cust: dev.customers[0])
                .previewLayout(.sizeThatFits)
            CustomerRowView(cust: dev.customers[0])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
