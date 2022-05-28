//
//  TripServices.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/17/22.
//

import Foundation
import Combine
import os.log
import Alamofire

class TripServices : ObservableObject {
    
    @Published var allTrips : [TripList] = []
    
    @Published var messageError : String?
    
    static let TAG =  "TripService :"
    
    var tripsSubcription : AnyCancellable?
    
    init() {
        
        
    }
    
    func get (_ terminal : String) {
        guard URL(string :"\(ApiConfig.TRIP_LIST_BY_TERMINAL)\(terminal)") != nil else {
            os_log("TripService: Error the url", log: OSLog.default, type: .debug)

            return
            
        }
        os_log("url %@",  "\(ApiConfig.TRIP_LIST_BY_TERMINAL)\(terminal)" )
        
        AF.request("\(ApiConfig.TRIP_LIST_BY_TERMINAL)\(terminal)"
                         , method: .get, parameters:nil,
                         encoding: JSONEncoding.default,
                         headers: ApiConfig.headers)
                  .validate()
                  .responseDecodable (of: TripListReceived.self) {
                      [weak self] (response) in
                      guard let data = response.value else { return}
                      guard data.status else {
                          
                          return
                      }
//                      guard let item =  data.data else {
//
//                          return
//                      }
                      self?.allTrips =  data.data
                      
                  }
        
                  .response {
                      response in
                      debugPrint(response)
                  }
        
        
//        tripsSubcription = NetWorkingManager.get(url: url, method: .GET)
//            .decode(type: TripListReceived.self, decoder: JSONDecoder())
//            .sink(receiveCompletion: NetWorkingManager.handleCompletion , receiveValue: { [weak self] (returndata) in
//                self?.allTrips =  returndata.data
//
//                       })
        
    }
}
