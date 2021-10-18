//
//  comentarios.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import SwiftUI

struct Comentarios: View {
    var comentList : [String]
    var body: some View {
//        let formGrid =  [
//            GridItem(.flexible())
//            ]
        
        ZStack {
            Color("Marine").ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Coments").foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.leading)
                ScrollView  {
                    VStack (alignment: .leading) {
                        //                    LazyHGrid(rows: formGrid, spacing : 8) {
                        ForEach(comentList, id : \.self) {
                            coment in
                           
                            
                            ZStack (alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("Blue-Gray"))
                                VStack (alignment: .leading) {
                                    HStack {
                                        Image("profile_sample").resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40)
                                            .padding(.leading)
                                        VStack {
                                            
                                            Text("Geoff ALto").foregroundColor(.white)
                                                .bold()
                                            Text("hace 7 dias").foregroundColor(.white)
                                                .font(.subheadline)
                                        }
                                    }.padding(.top, 8)
                                    
                                    Text(coment).foregroundColor(.white).padding()
                                }
                            }
                                
                            
                        }
                        
                        //                    }
                        
                        
                    }
                }.frame(maxWidth: .infinity).padding()
            }.frame(maxWidth : .infinity, alignment: .leading)
        }
    }
}

struct comentarios_Previews: PreviewProvider {
    static var previews: some View {
        Comentarios(comentList: ["He visto que como media tiene una gran calificación, y estoy completamente de acuerdo. Es el mejor juego que he jugado sin ninguna duda, combina una buena trama con una buenísima experiencia de juego libre gracias a su inmenso mapa y actividades.",
        "Mostrar imágenes dinámicamente de un servidor"
        ])
    }
}
