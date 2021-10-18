//
//  SearchGame.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import Foundation


class SearchGame: ObservableObject {
    
    @Published var gameInfo  = [Game]()
    
    
    func search(gamename : String) {
        
        gameInfo.removeAll()
        
        // aqui esto es para poner espacios
        
        let gameNameSpaces = gamename.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        let url = URL(string: "https://gamestream-api.herokuapp.com/api/games/search?contains=\(gameNameSpaces ?? "cuphead")")!
        
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do  {
                if let jsonData = data {
                    print("size del json\(jsonData)")
                    let decodeData = try JSONDecoder().decode(Resultados.self , from : jsonData)

                    // asincrona
                    DispatchQueue.main.async {
                        self.gameInfo.append(contentsOf: decodeData.results)
                    }
                }
            } catch {
                print("Error : \(error)")
                
            }
        }.resume()
    }
    
    
    init() {
        
    }
    
    
    
}
