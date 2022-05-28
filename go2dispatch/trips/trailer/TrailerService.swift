//
//  TrailerService.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/26/22.
//

import Foundation
import Combine
import os.log
import Alamofire

class TrailerService {
    
    @Published var allItem : [TrailerModel] = []
    @Published var messageError : String?
    
    static let TAG =  "TrailerService :"
    
    static let url = ApiConfig.TRAILER_LIST
    
    var trailerSubcription : AnyCancellable?
    
    init() {
        
        AF.request(TrailerService.url, method: .get, parameters: nil,  encoding: JSONEncoding.default,
                   headers: ApiConfig.headers)
        .validate()
        .responseDecodable(of: TrailerReceived.self) {
            [weak self] (response) in
            guard let data = response.value else {
                return
                
            }
            guard data.status ?? false else {
                return
            }
            self?.allItem = data.data ?? []
            
            
        }
        .response {
            response in
            debugPrint(response)
        }
        
        
    }
    
    func get() {
     
                
    }
    
}
