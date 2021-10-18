//
//  FavoritesView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import SwiftUI
import AVKit

struct FavoritesView: View {
    
    @ObservedObject var todosLosVideosJuegos =
    ViewModel()
    var body: some View {
        ZStack {
            Color("Marine").ignoresSafeArea()
            VStack {
                Text("FAVORITES")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom , 9.0)
                ScrollView {
                    
                    ForEach(todosLosVideosJuegos.gamesInfo, id : \.self) {
                        game in
                        
                        
                        VStack(spacing : 0) {
                            VideoPlayer(player: AVPlayer(url: URL(string: game.videosUrls.mobile)!))
                                .frame(height : 300)
                            Text("\(game.title)")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .background(Color("Blue-Gray"))
                                .clipShape(RoundedRectangle(cornerRadius: 3.0))
                            
                        }
                        
                    }
                        
                }.padding(.bottom, 8)
                
            }.padding(.horizontal, 6)
            
            // lo sigue mostrando es problema de xcode
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
        
        
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
