//
//  Gallery.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import SwiftUI
import Kingfisher

struct Gallery: View {
    var imgsUrl: [String]
    let formGrid =  [
        GridItem(.flexible())
        ]
    var body: some View {
        VStack(alignment:.leading) {
            Text("Gallery").foregroundColor(.white)
                .font(.largeTitle)
                .padding(.leading)
            ScrollView(.horizontal) {
                LazyHGrid(rows: formGrid, spacing : 8) {
                    ForEach(imgsUrl, id : \.self) {
                        imgsurl in
                        KFImage.init(URL(string: imgsurl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            
                    }
                    
                }
            }.frame(height:180)
        
            
        }.frame(maxWidth : .infinity, alignment: .leading)
    }
}

struct Gallery_Previews: PreviewProvider {
    static var previews: some View {
        Gallery(imgsUrl: ["https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_107600c1337accc09104f7a8aa7f275f23cad096.600x338.jpg",
                         "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_ed23139c916fdb9f6dd23b2a6a01d0fbd2dd1a4f.600x338.jpg"])
    }
}
