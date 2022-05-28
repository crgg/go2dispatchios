//
//  TrailerModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 5/26/22.
//

import Foundation


import Foundation

// MARK: - TrailerReceived
struct TrailerReceived: Codable {
    let status: Bool?
    let data: [TrailerModel]?
}

// MARK: - TrailerModel
struct TrailerModel: Codable {
    let trailerID, status, zone, finalDestination: String?
    let deliverBy, ownershipType, etaZone, etaDate: String?
    let lastLOCDate, currentZoneDesc, etaZoneDesc, owner: String?
    let nextMaintenance: JSONNull?
    let type, maximumWeight, currentTrip, lastTrip: String?
    let maximumLength, datumCLASS, sepriority, seremarks: String?
    let user1: JSONNull?
    let user2, user3: String?
    let user4, user5, user6, user7: JSONNull?
    let user8: JSONNull?
    let user9, user10, lastSatZone, lastSatDate: String?
    let lastSatLOC, poslat, poslong, tkDedicated: String?
    let tkDedicatedCommodity, tkCustomer: JSONNull?
    let nextTrip, finalDestinationDesc, secount4, secount3: String?
    let secount2, secount1, currentLOCClient: String?
    let chassisPool: JSONNull?

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

