//
//  Home.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/2/21.
//

import SwiftUI
import AVKit
struct Home: View {
    @State var tabSelected : Int = 1
    var body: some View {
        TabView (selection: $tabSelected) {
            
            ProfilView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Perfil")
                }.tag(0)
            
            GamesView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }.tag(2)
            
            ViewHome().tabItem {
                Image(systemName: "house")
                Text("Home")
            }.tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }.tag(0)
            
           
            
        }.accentColor(.white)
        
        
    }
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color("tabbarcolor"))
        UITabBar.appearance().isTranslucent = true
         
        
//        57,63,83
    }
}
struct ViewHome : View {
    
    @State var textSearch = ""
    
//    func search_driver() {
//        print("El driver \(textSearch)")
//    }
    
    var body: some View {
        
        
        ZStack {
            Color("Marine").ignoresSafeArea()
            
            VStack {
                
//                Image("app_logo").resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width:10, height: 10, alignment: .top)
//                    .padding(.horizontal, 8)
                
             
                
                ScrollView(showsIndicators: false) {
                    SubModuloHome()
                }
                
                
            }.padding(.horizontal, 18.0)
            
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
struct SubModuloHome : View {
    @State var textSearch = ""
    @ObservedObject var juegoEncontrado = SearchGame()
    @State var isGameViewActive =  false
    @State var url:String = ""
    @State var titulo:String = ""
    @State var studio:String = ""
    @State var calificacion: String = ""
    @State var anoPublicacion: String = ""
    @State var descripcion:String = ""
    @State var tags:[String] = [""]
    @State var imgsUrl: [String] = [""]
    
    
    
    @State var isGameInfoEmpty = false
//    @State var url = "https://cdn.cloudflare.steamstatic.com/steam/apps/256658589/movie480.mp4"
//        @State var isPlayerActive = false
//        let urlVideos:[String] = ["https://cdn.cloudflare.steamstatic.com/steam/apps/256658589/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256671638/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256720061/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256814567/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256705156/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256801252/movie480.mp4","https://cdn.cloudflare.steamstatic.com/steam/apps/256757119/movie480.mp4"]
//
    var body: some View {
        
        
        VStack {
            
            HStack {
                Button(action: {
                    
                    watchGame(name : textSearch)
                    
                    
                    
                    
                }, label: {
                    Image(systemName: "magnifyingglass").foregroundColor(textSearch.isEmpty ? .yellow  : Color("Dark-cian"))
                    
                }).alert(isPresented: $isGameInfoEmpty) {
                    Alert(title: Text("Error"), message: Text("not Found the game"), dismissButton: .default(Text("OK")))
                    
                }
                
                ZStack (alignment: .leading) {
                    if textSearch.isEmpty {
                        Text("Search Driver").foregroundColor(
                        Color( red: 174/255, green: 177/255, blue: 185/255, opacity: 1.0))
                    }
                    TextField("", text: $textSearch).foregroundColor(.white)
                     
                }
            }.padding([.top, .leading,.bottom], 11.0)
            .background(Color("Blue-Gray"))
            .clipShape(Capsule())
            
            
            
            Text("Los mas populares")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
                .frame(minWidth: 0 ,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.top)
            
            ZStack {
                Button(action: {
//                    url = urlVideos[0]
//                    print("url \(url)")
//                    isPlayerActive = true
                    watchGame(name: "Grand Theft Auto V")
                }
                       , label: {
                        VStack(spacing : 0) {
                            Image("13-swiftuiapps-2105-video-games").resizable().scaledToFill()
                            
                            Text("The witcher 3")
                                .background(Color("Blue-Gray"))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                })
                Image(systemName: "play.circle.fill").resizable()  .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                
                
            }.frame(minWidth: 0 ,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            .padding(.vertical)
            
            Text("Categorias Sugeridas para ti").font(.title3)
                .foregroundColor(.white)
                .bold()
                .frame(minWidth: 0 ,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
            ScrollView(.horizontal, showsIndicators : false) {
                HStack{
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Blue-Gray"))
                                .frame(width: 160, height: 90)
                            Image("Vector-shot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                            
                        }
                        
                        
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Blue-Gray"))
                                .frame(width: 160, height: 90)
                            Image("rpg_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                            
                        }
                        
                        
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Blue-Gray"))
                                .frame(width: 160, height: 90)
                            Image("Vector-shot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                            
                        }
                        
                        
                    })
                }
            }
            
            Text("Recomendados para ti")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
                .frame(minWidth:0 , maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false, content: {
                Button(action: {
                   watchGame(name: "Hades")
                }
                       , label: {
                        Image("13-swiftuiapps-2105-thewitcher").resizable()
                            .scaledToFit()
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            
                })
            })
            
        }
        NavigationLink(
                    destination: GameView(url: url, titulo: titulo, studio: studio, calificacion: calificacion, anoPublicacion: anoPublicacion, descripcion: descripcion, tags: tags, imgsUrl: imgsUrl)
                        ,
                    isActive: $isGameViewActive,
            
                    label: {
                       
                        
                        EmptyView()
                    })
    
    }
    
    func watchGame(name: String) {
//        print(name)
//        isGameInfoEmpty = true
        juegoEncontrado.search(gamename: name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            
            print("cantidad E: \(juegoEncontrado.gameInfo.count)")
            if juegoEncontrado.gameInfo.count == 0 {
                isGameInfoEmpty = true
            } else {
                url = juegoEncontrado.gameInfo[0].videosUrls.mobile
                titulo = juegoEncontrado.gameInfo[0].title
                studio = juegoEncontrado.gameInfo[0].studio
                calificacion = juegoEncontrado.gameInfo[0].contentRaiting
                anoPublicacion = juegoEncontrado.gameInfo[0].publicationYear
                descripcion = juegoEncontrado.gameInfo[0].gameDescription
                tags =  juegoEncontrado.gameInfo[0].tags
                imgsUrl = juegoEncontrado.gameInfo[0].galleryImages
                isGameViewActive = true
            }
            
            
            
        }
        
        
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
