//
//  TripModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation


struct TripList : Identifiable {
    let id = UUID()
    var trip_number : Int
    var description : String?
    var trailer_id : String?
    var dispatcher_id : String?
    var driver_id : String?
    var truck_id : String?
    
    enum CodingKeys : String, CodingKey {
        case trip_number = "TRIP_NUMBER"
        case description = "DESCRIPTION"
        case trailer_id = "TRAILER"
        case dispatcher_id = "DISPATCH"
        case driver_id = "DRIVER"
        case truck_id = "TRUCK"
    }
     
}

extension TripList : Codable {
    init(from decoder : Decoder) throws {
          let values =  try decoder.container(keyedBy: CodingKeys.self)
          trailer_id = try? values.decode(String.self, forKey: .trailer_id)
          dispatcher_id = try? values.decode(String.self, forKey: .dispatcher_id)
          driver_id = try? values.decode(String.self, forKey: .driver_id)
          truck_id = try? values.decode(String.self, forKey: .truck_id)
          trip_number = try values.decode(Int.self, forKey: .trip_number)
          description = try? values.decode(String.self, forKey: .description)
      }
}

extension TripList {
     static let sampleTrips =
    [
        TripList(trip_number: 650186, description: nil, trailer_id: nil, dispatcher_id: "STASZEKG", driver_id: "CHRISTOP", truck_id: "DMS 1265"),
        TripList(trip_number: 650187, description: "CSX MA3", trailer_id: nil, dispatcher_id: "PAWELG", driver_id: nil, truck_id: nil),
        TripList(trip_number: 650188, description: "CSX MA4", trailer_id: "53300" , dispatcher_id: "PAWELG", driver_id: "null", truck_id: nil)
    ]
}
