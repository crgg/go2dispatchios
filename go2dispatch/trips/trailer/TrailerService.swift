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


enum ServiceMessages {
    
    case error(msg : String)
    case msg(msg : String)
    case warring(msg : String)
    case success(trip : TripList)
    case nothing
}

class TrailerService {
    
    @Published var allItem : [TrailerModel] = []
 
    @Published var serviceMessages : ServiceMessages = .nothing
    
    static let TAG =  "TrailerService :"
    
    static let url = ApiConfig.TRAILER_LIST
    static let assign = ApiConfig.ASSIGN_TRAILER
    
    var trailerSubcription : AnyCancellable?
    
    init() {
        
 
        get()
        
    }
    
    func get() {
     
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
    
    
    
    func assignTrailer(trailer: String, trip_number : Int, terminal_zone: String, warning : Bool) {
    
        let param : [String : Any] = [
            "TERMINAL_ZONE" : terminal_zone,
            "TRIP_NUMBER" : trip_number,
            "TRAILER_ID" : trailer,
            "warning" : warning
            
        ]
        
        AF.request(TrailerService.assign, method: .post, parameters: param,  encoding: JSONEncoding.default,
                   headers: ApiConfig.headers)
        .validate()
        .responseDecodable(of: TrailerResponse.self) {
            [weak self] (response) in
            guard let data = response.value else {
                
                self?.serviceMessages =  .error(msg: "Please try again later")
               
                return
                
            }
            guard data.status else {
                if let error = data.error {
                    if data.warning ?? false {
                        self?.serviceMessages =  .warring(msg: error)
                        return
                    }
                    self?.serviceMessages =  .error(msg: error)
                    return
                    
                }
                self?.serviceMessages =  .error(msg: "no permit")
                
                return
            }
            if let trip = data.data   {
                self?.serviceMessages =  .success(trip: trip)
                return
            }
            
        
            
            
        }
        .response {
            response in
            debugPrint(response)
        }
    }
}
