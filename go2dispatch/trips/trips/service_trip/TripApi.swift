//
//  TripApi.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/17/22.
//

import Foundation


class TripApi {
    
    
    static func getTripByTerminal(_ terminal : String) {
        let url = URL(string :"\(ApiConfig.TRIP_LIST_BY_TERMINAL)\(terminal)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

      
        
    }
    
}
