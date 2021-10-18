//
//  GameView.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import SwiftUI
import AVKit

struct GameView: View {
    
    var url:String
    var titulo:String
    var studio:String
    var calificacion: String
    var anoPublicacion: String
    var descripcion:String
    var tags:[String]
    var imgsUrl: [String]
    
    var body: some View {
        ZStack {
            Color("Marine").ignoresSafeArea()
            VStack {
                video(url:url).frame(height:300)
                ScrollView {
                    
                    // info video
                    videoInfo(titulo: titulo, studio :studio,
                              calificacion: calificacion,
                              anoPublicacion: anoPublicacion,
                              descripcion : descripcion,
                              tags : tags).padding()
                        .foregroundColor(.white)
                   
                        Gallery(imgsUrl: imgsUrl)
                    Comentarios(comentList: ["He visto que como media tiene una gran calificación, y estoy completamente de acuerdo. Es el mejor juego que he jugado sin ninguna duda, combina una buena trama con una buenísima experiencia de juego libre gracias a su inmenso mapa y actividades.",
                                             "He visto que como media tiene una gran calificación, y estoy completamente de acuerdo. Es el mejor juego que he jugado sin ninguna duda, combina una buena trama con una buenísima experiencia de juego libre gracias a su inmenso mapa y actividades.",
                                            " He visto que como media tiene una gran calificación, y estoy completamente de acuerdo. Es el mejor juego que he jugado sin ninguna duda, combina una buena trama con una buenísima experiencia de juego libre gracias a su inmenso mapa y actividades."
                                             ])
                }.frame(maxWidth: .infinity)
            }
        }
    }
}

 


struct videoInfo : View {
  
    var titulo:String
    var studio:String
    var calificacion: String
    var anoPublicacion: String
    var descripcion:String
    var tags:[String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(titulo)").foregroundColor(.white)
                .font(.largeTitle)
                .padding(.leading)
            
            HStack {
                Text("\(studio) \(calificacion) \(anoPublicacion)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top, 5)
                    .padding(.leading)
                
            }
            Text(descripcion).foregroundColor(.white)
                .font(.subheadline)
                .padding(.top, 5)
                .padding(.leading)
            
            HStack {
                ForEach(tags, id:\.self) {
                    tag in
                    Text("\(tag)").foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.top, 4)
                        .padding(.leading)
                }
            }
            
            
        }.frame(maxWidth:.infinity, alignment: .leading)
    }
}

struct video : View {
    
    var url : String
    
    var body: some View {
        
        VideoPlayer(player: AVPlayer(url: URL(string: url)!)).ignoresSafeArea()
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(url: "Ejemplo.com", titulo: "Sonic", studio: "Sega", calificacion: "E+", anoPublicacion: "1991", descripcion: "juego antigu odadsd dd ", tags: ["plataformas" , "mascotas"], imgsUrl: ["https://cdn.cloudflare.steamstatic.com/steam/apps/256658589/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256671638/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256720061/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256814567/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256705156/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256801252/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256757119/movie480.mp4"])
    }
}
