//
//  TrailerModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/26/22.
//

import Foundation


import Foundation


struct TrailerResponse : Codable {
    let status : Bool
    let data : TripList?
    let error: String?
    let warning : Bool?
    
    
    
}

// MARK: - TrailerReceived
struct TrailerReceived: Codable {
    let status: Bool?
    let data: [TrailerModel]?
}

// MARK: - TrailerModel
struct TrailerModel: Codable, Identifiable {
    var id : String {trailerID}
    let trailerID : String
    let status : String
    let  zone, finalDestination: String?
    let deliverBy, ownershipType, etaZone, etaDate: String?
    let lastLOCDate, currentZoneDesc, etaZoneDesc, owner: String?
    let nextMaintenance: String?
    let currentTrip : String?
    let type, maximumWeight,  lastTrip: String?
    
    let maximumLength, datumCLASS, sepriority, seremarks: String?
    let user1: String?
    let user2, user3: String?
    let user4, user5, user6, user7: String?
    let user8: String?
    let user9, user10, lastSatZone, lastSatDate: String?
    let lastSatLOC, poslat, poslong, tkDedicated: String?
    let tkDedicatedCommodity, tkCustomer: String?
    let nextTrip, finalDestinationDesc, secount4, secount3: String?
    let secount2, secount1, currentLOCClient: String?
    let chassisPool: String?

    enum CodingKeys: String, CodingKey {
        case trailerID = "TRAILER_ID"
        case status = "STATUS"
        case zone = "ZONE"
        case finalDestination = "FINAL_DESTINATION"
        case deliverBy = "DELIVER_BY"
        case ownershipType = "OWNERSHIP_TYPE"
        case etaZone = "ETA_ZONE"
        case etaDate = "ETA_DATE"
        case lastLOCDate = "LAST_LOC_DATE"
        case currentZoneDesc = "CURRENT_ZONE_DESC"
        case etaZoneDesc = "ETA_ZONE_DESC"
        case owner = "OWNER"
        case nextMaintenance = "NEXT_MAINTENANCE"
        case type = "TYPE"
        case maximumWeight = "MAXIMUM_WEIGHT"
        case currentTrip = "CURRENT_TRIP"
        case lastTrip = "LAST_TRIP"
        case maximumLength = "MAXIMUM_LENGTH"
        case datumCLASS = "CLASS"
        case sepriority = "SEPRIORITY"
        case seremarks = "SEREMARKS"
        case user1 = "USER1"
        case user2 = "USER2"
        case user3 = "USER3"
        case user4 = "USER4"
        case user5 = "USER5"
        case user6 = "USER6"
        case user7 = "USER7"
        case user8 = "USER8"
        case user9 = "USER9"
        case user10 = "USER10"
        case lastSatZone = "LAST_SAT_ZONE"
        case lastSatDate = "LAST_SAT_DATE"
        case lastSatLOC = "LAST_SAT_LOC"
        case poslat = "POSLAT"
        case poslong = "POSLONG"
        case tkDedicated = "TK_DEDICATED"
        case tkDedicatedCommodity = "TK_DEDICATED_COMMODITY"
        case tkCustomer = "TK_CUSTOMER"
        case nextTrip = "NEXT_TRIP"
        case finalDestinationDesc = "FINAL_DESTINATION_DESC"
        case secount4 = "SECOUNT4"
        case secount3 = "SECOUNT3"
        case secount2 = "SECOUNT2"
        case secount1 = "SECOUNT1"
        case currentLOCClient = "CURRENT_LOC_CLIENT"
        case chassisPool = "CHASSIS_POOL"
    }
}

extension TrailerModel {
    
     static let sampleTrailer = [
     TrailerModel(
         trailerID : "53357",
         status: "SPOTEMPTY",
         zone: "89434",
         finalDestination: "RENOTERM",
         deliverBy: "2022-03-28 16:00:00.000000",
         ownershipType: "L",
         etaZone: "RENOTERM",
         etaDate: "2022-03-28 14:00:00.000000",
         lastLOCDate: "2022-03-31 09:27:22.000000",
         currentZoneDesc: "SPARKS, NV",
         etaZoneDesc: "RENOTERM",
         owner: "TOGOEX",
         nextMaintenance: nil,
         currentTrip: "733333", type: "UTILITY",
         maximumWeight: "0.00000000000000E+000",
         lastTrip: "726676",
         maximumLength: "5.30000000000000E+001",
         datumCLASS: "R",
         sepriority: "0",
         seremarks: "",
         user1: nil,
         user2: "BLUE TREE ",
         user3: "NO START",
         user4: nil,
         user5: nil,
         user6: nil,
         user7: nil,
         user8: nil,
         user9: "",
         user10: "",
         lastSatZone: "89434",
         lastSatDate: "2022-04-06 18:43:40.000000",
         lastSatLOC: "I 80, Sparks, NV, 89431-5025",
         poslat: "0393137N",
         poslong: "1194245W",
         tkDedicated: "False",
         tkDedicatedCommodity: nil,
         tkCustomer: nil,
         nextTrip: "0",
         finalDestinationDesc: "RENOTERM",
         secount4: "0",
         secount3: "0",
         secount2: "0",
         secount1: "0",
         currentLOCClient: "",
         chassisPool: nil
     )
    ]
}
