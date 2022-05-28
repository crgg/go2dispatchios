//
//  ShowDocuments.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/7/22.
//

import SwiftUI

struct ShowDocuments: View {
    @State var fotos : [fotos]
    
    @State var freight : Freight
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
         
            ScrollView  {
                ForEach(fotos, id:\.id) { i  in
                    
                    GeometryReader{
                        proxy in
                    
                        PDFKitView(url: i.avatar, key: String(i.id))
                    }
                }
            }
                
                
        }
        .overlay(
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                    Text("Freight \(self.freight.BILL_NUMBER)")
                        .font(.title2.bold())
                    Spacer(minLength: 0)
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up.fill"
                        )
                            .font(.title2)
                    }
                }
            }.foregroundColor(.white)
                .padding()
                .background(BlurView(style: .systemThinMaterialDark).ignoresSafeArea())
               
                
            ,
            alignment: .top
        )
        
    }
}

struct ShowDocuments_Previews: PreviewProvider {
    static var previews: some View {
        ShowDocuments(fotos: TripList.sampleTrips[0].freights[0].fotos.filter({ $0.typedocument == "D"  }), freight: TripList.sampleTrips[0].freights[0])
    }
}
