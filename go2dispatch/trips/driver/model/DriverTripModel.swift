//
//  DriverTripModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/10/22.
//

import Foundation

struct driver_trip_data_received : Codable {
    let data : [DriverTripModel]
    
}

struct DriverTripModel : Codable, Identifiable {
    var id : String { DRIVER_ID }
    var DRIVER_ID : String
    var STATUS : String
    var CURRENT_ZONE : String
    var FINAL_DESTINATION : String?
    var DELIVER_BY : String?
    var NAME : String
    var DRIVER_TYPE : String?
    var DRIVER_EMPLOYMENT : String?
    var DEFAULT_PUNIT : String?
    var CURRENT_ZONE_DESC : String?
    var CURRENT_TRIP : String?
    var LAST_TRIP : String?
    var OTHER_CODE : String?
    var LICENCE_NUMBER : String?
    var EXPIRY_DATE : String?
    var CELL_PHONE : String?
    var LAST_SAT_ZONE : String?
    var LAST_SAT_DATE : String?
    var LAST_SAT_LOC : String?
    var NEXT_TRIP : String?
    var FINAL_DESTINATION_DESC : String?
    
}

extension DriverTripModel {
  static  let sample = [
        DriverTripModel(
            DRIVER_ID : "ADAMOLESZK",
                 STATUS : "PICKED",
                 CURRENT_ZONE : "98045",
                 FINAL_DESTINATION : "98390",
                 DELIVER_BY : "2021-09-01 09:15:00.000000",
                 NAME : "ADAM  OLESZKOWICZ",
                 DRIVER_TYPE : "O",
                 DRIVER_EMPLOYMENT : "ADAMOL",
                 DEFAULT_PUNIT : "716",
                 CURRENT_ZONE_DESC : "NORTH BEND, WA",
                 CURRENT_TRIP : "649606",
                 LAST_TRIP : "646706",
                 OTHER_CODE : "OTR",
                 LICENCE_NUMBER : "VF690072",
                 EXPIRY_DATE : nil,
                 CELL_PHONE : "347 221-9012",
                 LAST_SAT_ZONE : "98045",
                 LAST_SAT_DATE : "2021-08-31 03:53:44.000000",
                 LAST_SAT_LOC : "Southeast 150th Street, Riverbend, WA, 98045",
                 NEXT_TRIP : "650347",
                 FINAL_DESTINATION_DESC : "SUMNER, WA"
        
        ),
        DriverTripModel(
            DRIVER_ID : "ANTHONYLOM",
                     STATUS : "AVAIL",
                     CURRENT_ZONE : "NLTERM",
                     FINAL_DESTINATION : "NLTERM",
                     DELIVER_BY : "2021-08-30 19:00:00.000000",
                     NAME : "ANTHONY  LOMBARDO (LOCAL)",
                     DRIVER_TYPE : "C",
                     DRIVER_EMPLOYMENT : nil,
                     DEFAULT_PUNIT : "254",
                     CURRENT_ZONE_DESC : "NLTERM",
                     CURRENT_TRIP : "0",
                     LAST_TRIP : "649687",
                     OTHER_CODE : "LOC/PAYROL",
                     LICENCE_NUMBER : "L516-0058-0188",
                     EXPIRY_DATE : nil,
                     CELL_PHONE : "708 200-0253",
                     LAST_SAT_ZONE : "60141",
                     LAST_SAT_DATE : "2021-08-31 00:00:32.000000",
                     LAST_SAT_LOC : "2472 1st Avenue, North Riverside, IL, 60546",
                     NEXT_TRIP : "0",
                     FINAL_DESTINATION_DESC : "NLTERM"
        ),
        DriverTripModel(
            DRIVER_ID : "BEAUW",
              STATUS : "AVAIL",
              CURRENT_ZONE : "NLTERM",
              FINAL_DESTINATION : nil,
              DELIVER_BY : nil,
              NAME : "BEAU  WHITENACK",
              DRIVER_TYPE : "C",
              DRIVER_EMPLOYMENT : nil,
              DEFAULT_PUNIT : nil,
              CURRENT_ZONE_DESC : "NLTERM",
              CURRENT_TRIP : "0",
              LAST_TRIP : "0",
              OTHER_CODE : nil,
              LICENCE_NUMBER : nil,
              EXPIRY_DATE : nil,
              CELL_PHONE : nil,
              LAST_SAT_ZONE : nil,
              LAST_SAT_DATE : nil,
              LAST_SAT_LOC : nil,
              NEXT_TRIP : "0",
              FINAL_DESTINATION_DESC : nil
        )
    
    ]
    
}
