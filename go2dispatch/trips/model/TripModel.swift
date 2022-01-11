//
//  TripModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation


struct TripList : Identifiable {
    var id : Int {trip_number}
    var trip_number : Int
    var description : String?
    var trailer_id : String?
    var dispatcher_id : String?
    var driver_id : String?
    var truck_id : String?
    var status : String
    var current_zone : String?
    var current_zone_desc : String?
    var expland : Bool = false
    var freights : [Freight]
    
    
    enum CodingKeys : String, CodingKey {
        case trip_number = "TRIP_NUMBER"
        case description = "DESCRIPTION"
        case trailer_id = "TRAILER"
        case dispatcher_id = "DISPATCH"
        case driver_id = "DRIVER"
        case truck_id = "TRUCK"
        case status = "STATUS"
        case current_zone = "CURRENT_ZONE"
        case current_zone_desc = "CURRENT_ZONE_DESC"
        case freights = "freights"
    }
     
}

struct FilterList : Identifiable {
    let id : UUID = UUID()
    let name : String
}

extension TripList : Codable  {
    init(from decoder : Decoder) throws {
          let values =  try decoder.container(keyedBy: CodingKeys.self)
          trailer_id = try? values.decode(String.self, forKey: .trailer_id)
          dispatcher_id = try? values.decode(String.self, forKey: .dispatcher_id)
          driver_id = try? values.decode(String.self, forKey: .driver_id)
          truck_id = try? values.decode(String.self, forKey: .truck_id)
          trip_number = try values.decode(Int.self, forKey: .trip_number)
          description = try? values.decode(String.self, forKey: .description)
          status = try values.decode(String.self, forKey: .status)
          current_zone = try? values.decode(String.self, forKey: .current_zone)
           freights = try values.decode([Freight].self, forKey: .freights)

      }
}


struct Freight :Identifiable, Codable {
    var id : String = UUID().uuidString
    var CURR_ZONE_DESC : String?
    var TRIP_NUMBER : Int
    var BILL_NUMBER: String
    var LEG_SEQUENCE : String
    var START_CITY :  String
    var ROUTE_SEQUENCE : String
    var START_STATE : String?
    var END_CITY :  String?
    var END_STATE : String?
    var BILL_STATUS :  String?
    var DETAIL_LINE_ID : Int
    var TX_TYPE  : String?
    var TYPE :  String?
    var PIECES  : String?
    var PALLETS : String?
    var WEIGHT :  String?
    var PICKUP_BY : String?
    var DELIVER_BY : String?
    var DESTNAME :  String?
    var ORIGNAME :  String?
    var DESTPHONE :  String?
    var PICKUP_DONE :  String?
    var DELIVERY_DONE :  String?
    var ADDRESS_ORIGIN :  String?
    var ORIGPC :  String?
    var ADDRESS_DESTINE :  String?
    var DESTPC :  String?
    var TEMP_CONTROLLED :  String?
    var TEMPERATURE :  String?
    var ISSURVEY : Bool
    var fotos : [fotos]
      
}
struct fotos : Codable, Identifiable {
    let id : Int
    let typedocument : String
    let avatar : String
    let created_at : String
    let systemfrom : String
    
}



extension TripList {
     static let sampleTrips =
    [
        TripList(trip_number: 594441, description: nil, trailer_id: nil, dispatcher_id: "STEPHANIEL", driver_id: nil, truck_id: nil, status: "ASSIGN",current_zone: "92081", current_zone_desc: "VISTA, CA",  freights: [
            Freight(
                CURR_ZONE_DESC : "CHICAGO, IL",
                TRIP_NUMBER : 594441,
                BILL_NUMBER : "502608    ",
                LEG_SEQUENCE : "1",
                START_CITY : "PITTSBURGH",
                ROUTE_SEQUENCE : "2",
                START_STATE : "PA",
                END_CITY : "CHICAGO",
                END_STATE : "IL",
                BILL_STATUS : "BILLD",
                DETAIL_LINE_ID : 756912,
                TX_TYPE : "D",
                TYPE : "DELIVERY",
                PIECES : "30",
                PALLETS : "30.00",
                WEIGHT : "1500",
                PICKUP_BY : "03/08/2021",
                DELIVER_BY : "03/09/2021",
                DESTNAME : "VILLEGAS MATTRESS",
                ORIGNAME : "MATTRESS FIRM",
                DESTPHONE : "773 770 4504",
                PICKUP_DONE : "True",
                DELIVERY_DONE : "True",
                ADDRESS_ORIGIN : "55 38TH ST , PITTSBURGH , PA ,15201",
                ORIGPC : "15201",
                ADDRESS_DESTINE : "2600 W 35TH ST , CHICAGO ,  IL , 60632",
                DESTPC : "60632",
                TEMP_CONTROLLED: "False",
                TEMPERATURE : "",
                ISSURVEY : false,
                fotos : [
                        fotos(
                        id: 867,
                        typedocument: "F",
                        avatar: "https://media.goto-logistics.com/TruckmateDownload/FBPICS/2022/January/07/555151.jpg",
                        created_at : "2021-11-18 15:41:32",
                        systemfrom : "DRIVERAPP"
                     ),
                      fotos(
                        id: 868,
                        typedocument : "F",
                        avatar : "https://media.goto-logistics.com/TruckmateDownload/FBPICS/2022/January/07/554964.jpg",
                        created_at : "2021-11-18 15:42:06",
                        systemfrom : "DRIVERAPP"
                    ),
                    fotos(
                        id: 869,
                        typedocument: "F",
                        avatar : "https://media.goto-logistics.com/TruckmateDownload/FBPICS/2022/January/07/555405.jpg",
                        created_at: "2021-11-18 16:00:58",
                        systemfrom: "DRIVERAPP"
                    ),
                    fotos(
                            id: 870,
                            typedocument: "F",
                            avatar : "https://media.goto-logistics.com/TruckmateDownload/FBPICS/2022/January/07/554426_4.jpg",
                            created_at: "2021-11-18 16:00:58",
                            systemfrom: "DRIVERAPP"
                      ),
                    fotos(
                            id: 875,
                            typedocument: "D",
                            avatar : "https://media.goto-logistics.com/TruckmateDownload/DOC/BOL/BOL-555306.pdf",
                            created_at: "2021-11-18 16:00:58",
                            systemfrom: "DRIVERAPP"
                       ),
                        fotos(
                                id: 876,
                                typedocument: "D",
                                avatar : "https://media.goto-logistics.com/TruckmateDownload/DOC/BOL/BOL-554635.pdf",
                                created_at: "2021-11-18 16:00:58",
                                systemfrom: "DRIVERAPP"
                           ),
                        fotos(
                                id: 877,
                                typedocument: "D",
                                avatar : "https://media.goto-logistics.com/TruckmateDownload/DOC/BOL/BOL-554825.pdf",
                                created_at: "2021-11-18 16:00:58",
                                systemfrom: "DRIVERAPP"
                           ),
                        
                        
                ]
            ),
           
            Freight(
                CURR_ZONE_DESC : "BRONX, NY",
                TRIP_NUMBER : 594441,
                BILL_NUMBER : "503077    ",
                LEG_SEQUENCE : "3",
                START_CITY : "JOLIET",
                ROUTE_SEQUENCE : "3",
                START_STATE : "IL",
                END_CITY : "BRONX",
                END_STATE : "NY",
                BILL_STATUS : "BILLD",
                DETAIL_LINE_ID : 758009,
                TX_TYPE : "P",
                TYPE : "PICKUP",
                PIECES : "26",
                PALLETS : "26.00",
                WEIGHT : "14126",
                PICKUP_BY : "03/09/2021",
                DELIVER_BY : "03/10/2021",
                DESTNAME : "TARGET 3280",
                ORIGNAME : "TARGET JOLIET IRL",
                DESTPHONE : "",
                PICKUP_DONE : "True",
                DELIVERY_DONE : "True",
                ADDRESS_ORIGIN : "3300 CHANNAHON RD , JOLIET , IL ,60436",
                ORIGPC : "60436",
                ADDRESS_DESTINE : "305 CASANOVA ST , BRONX ,  NY , 10474",
                DESTPC : "10474",
                TEMP_CONTROLLED : "False",
                TEMPERATURE : "",
                ISSURVEY : false,
                fotos : []
            ),
            Freight(
                CURR_ZONE_DESC: "BRONX, NY",
                TRIP_NUMBER: 594441,
                BILL_NUMBER: "503077    ",
                LEG_SEQUENCE: "3",
                START_CITY: "JOLIET",
                ROUTE_SEQUENCE: "3",
                START_STATE: "IL",
                END_CITY: "BRONX",
                END_STATE: "NY",
                BILL_STATUS: "BILLD",
                DETAIL_LINE_ID: 758009,
                TX_TYPE: "P",
                TYPE: "PICKUP",
                PIECES: "26",
                PALLETS: "26.00",
                WEIGHT: "14126",
                PICKUP_BY: "03/09/2021",
                DELIVER_BY: "03/10/2021",
                DESTNAME: "TARGET 3280",
                ORIGNAME: "TARGET JOLIET IRL",
                DESTPHONE: "",
                PICKUP_DONE: "True",
                DELIVERY_DONE: "True",
                ADDRESS_ORIGIN: "3300 CHANNAHON RD , JOLIET , IL ,60436",
                ORIGPC: "60436",
                ADDRESS_DESTINE: "305 CASANOVA ST , BRONX ,  NY , 10474",
                DESTPC: "10474",
                TEMP_CONTROLLED: "False",
                TEMPERATURE: "",
                ISSURVEY: false,
                fotos : []
            )
        ]),
                     
        TripList(trip_number: 569833, description: "Z", trailer_id: nil, dispatcher_id: "JACEKK", driver_id: nil, truck_id: nil, status: "DISP", current_zone_desc : "NLTERM", freights: []
        ),
        TripList(trip_number: 645507, description: "zFL", trailer_id: "53628" , dispatcher_id: "ANITAG", driver_id: "ROBERTBURB", truck_id: "AR107", status: "PICKED", current_zone_desc : "ZEPHYRHILLS, FL",
                 freights  : [
                                Freight (
                                     CURR_ZONE_DESC : "ORLANDO, FL",
                                     TRIP_NUMBER : 645507,
                                     BILL_NUMBER : "531208    ",
                                     LEG_SEQUENCE : "1",
                                     START_CITY : "WAUKESHA",
                                     ROUTE_SEQUENCE : "2",
                                     START_STATE : "WI",
                                     END_CITY : "ORLANDO",
                                     END_STATE : "FL",
                                     BILL_STATUS : "BILLD",
                                     DETAIL_LINE_ID : 820148,
                                     TX_TYPE : "D",
                                     TYPE : "DELIVERY",
                                     PIECES : "4",
                                     PALLETS : "4.00",
                                     WEIGHT : "8836",
                                     PICKUP_BY : "08/16/2021",
                                     DELIVER_BY : "08/19/2021",
                                     DESTNAME : "LA CHIQUITA TORTILLA",
                                     ORIGNAME : "KG MARKETING AND BAG CO",
                                     DESTPHONE : "404 290 2064",
                                     PICKUP_DONE : "True",
                                     DELIVERY_DONE : "True",
                                     ADDRESS_ORIGIN : "1201 S GRANDVIEW BLVD , WAUKESHA , WI ,53188",
                                     ORIGPC : "53188",
                                     ADDRESS_DESTINE : "6918 PRESIDENTS DR , ORLANDO ,  FL , 32809",
                                     DESTPC : "32809",
                                     TEMP_CONTROLLED : "False",
                                     TEMPERATURE : "",
                                     ISSURVEY : true,
                                     fotos : []
                                ),
                                 Freight(
                                   CURR_ZONE_DESC : "TAMPA, FL",
                                   TRIP_NUMBER : 645507,
                                   BILL_NUMBER : "530310  "  ,
                                   LEG_SEQUENCE : "1",
                                   START_CITY : "SANTA CLARA",
                                   ROUTE_SEQUENCE : "3",
                                   START_STATE : "CA",
                                   END_CITY : "TAMPA",
                                   END_STATE : "FL",
                                   BILL_STATUS : "BILLD",
                                   DETAIL_LINE_ID : 817957,
                                   TX_TYPE : "D",
                                   TYPE : "DELIVERY",
                                   PIECES : "1",
                                   PALLETS : "3.00",
                                   WEIGHT : "2500",
                                   PICKUP_BY : "08/10/2021",
                                   DELIVER_BY : "08/19/2021",
                                   DESTNAME : "U HAUL",
                                   ORIGNAME : "UHAUL",
                                   DESTPHONE : "813 242 4295",
                                   PICKUP_DONE : "True",
                                   DELIVERY_DONE : "True",
                                   ADDRESS_ORIGIN : "2121 LAURELWOOD RD , SANTA CLARA , CA ,95054",
                                   ORIGPC : "95054",
                                   ADDRESS_DESTINE : "4001 E LAKE AVE , TAMPA ,  FL , 33610",
                                   DESTPC : "33610",
                                   TEMP_CONTROLLED : "False",
                                   TEMPERATURE : "",
                                   ISSURVEY : true,
                                   fotos : []
                                 ),
                                 Freight(
                              CURR_ZONE_DESC : "BRADENTON, FL",
                              TRIP_NUMBER : 645507,
                              BILL_NUMBER : "529738    ",
                              LEG_SEQUENCE : "1",
                              START_CITY : "HENDERSON",
                              ROUTE_SEQUENCE : "4",
                              START_STATE : "NV",
                              END_CITY : "BRADENTON",
                              END_STATE : "FL",
                              BILL_STATUS : "BILLD",
                              DETAIL_LINE_ID : 816472,
                              TX_TYPE : "D",
                              TYPE : "DELIVERY",
                              PIECES : "1",
                              PALLETS : "3.00",
                              WEIGHT : "2500",
                              PICKUP_BY : "08/11/2021",
                              DELIVER_BY : "08/19/2021",
                              DESTNAME : "U-HAUL",
                              ORIGNAME : "U-HAUL MOVING & STORAGE AT COLLEGE",
                              DESTPHONE : "",
                              PICKUP_DONE : "True",
                              DELIVERY_DONE : "True",
                              ADDRESS_ORIGIN : "989 S BOULDER HWY , HENDERSON , NV ,89015",
                              ORIGPC : "89015",
                              ADDRESS_DESTINE : "3602 14TH ST W , BRADENTON ,  FL , 34205",
                              DESTPC : "34205",
                              TEMP_CONTROLLED : "False",
                              TEMPERATURE : "",
                              ISSURVEY : true,
                              fotos : []
                                 ),
                                 Freight(
                              CURR_ZONE_DESC : "SARASOTA, FL",
                              TRIP_NUMBER : 645507,
                              BILL_NUMBER : "530400    ",
                              LEG_SEQUENCE : "1",
                              START_CITY : "HENDERSON",
                              ROUTE_SEQUENCE : "5",
                              START_STATE : "NV",
                              END_CITY : "SARASOTA",
                              END_STATE : "FL",
                              BILL_STATUS : "BILLD",
                              DETAIL_LINE_ID : 818139,
                              TX_TYPE : "D",
                              TYPE : "DELIVERY",
                              PIECES : "2",
                              PALLETS : "6.00",
                              WEIGHT : "5000",
                              PICKUP_BY : "08/11/2021",
                              DELIVER_BY : "08/19/2021",
                              DESTNAME : "UHAUL 830064",
                              ORIGNAME : "UHAUL 838056",
                              DESTPHONE : "(941) 355-8535",
                              PICKUP_DONE : "True",
                              DELIVERY_DONE : "True",
                              ADDRESS_ORIGIN : "989 S BOULDER HWY , HENDERSON , NV ,89015",
                              ORIGPC : "89015",
                              ADDRESS_DESTINE : "7850 N TAMIAMI TR , SARASOTA ,  FL , 34243",
                              DESTPC : "34243",
                              TEMP_CONTROLLED : "False",
                              TEMPERATURE : "",
                              ISSURVEY : true,
                              fotos : []
                                 ),
                                 Freight(
                              CURR_ZONE_DESC : "NORTH FORT MYERS, FL",
                              TRIP_NUMBER : 645507,
                              BILL_NUMBER : "530886    ",
                              LEG_SEQUENCE : "1",
                              START_CITY : "WEST DUNDEE",
                              ROUTE_SEQUENCE : "6",
                              START_STATE : "IL",
                              END_CITY : "NORTH FORT MYERS",
                              END_STATE : "FL",
                              BILL_STATUS : "BILLD",
                              DETAIL_LINE_ID : 819345,
                              TX_TYPE : "D",
                              TYPE : "DELIVERY",
                              PIECES : "1",
                              PALLETS : "3.00",
                              WEIGHT : "2500",
                              PICKUP_BY : "08/16/2021",
                              DELIVER_BY : "08/19/2021",
                              DESTNAME : "UHAUL 830025",
                              ORIGNAME : "UHAUL",
                              DESTPHONE : "(239) 567-9179",
                              PICKUP_DONE : "True",
                              DELIVERY_DONE : "True",
                              ADDRESS_ORIGIN : "890 W MAIN ST , WEST DUNDEE , IL ,60118",
                              ORIGPC : "60118",
                              ADDRESS_DESTINE : "16901 N CLEVELAND AVE , NORTH FORT MYERS ,  FL , 33903",
                              DESTPC : "33903",
                              TEMP_CONTROLLED : "False",
                              TEMPERATURE : "",
                              ISSURVEY : true,
                              fotos : []
                                 ),
                                 Freight(
                              CURR_ZONE_DESC : "NORTH FORT MYERS, FL",
                              TRIP_NUMBER : 645507,
                              BILL_NUMBER : "530956    ",
                              LEG_SEQUENCE : "1",
                              START_CITY : "PEORIA",
                              ROUTE_SEQUENCE : "7",
                              START_STATE : "IL",
                              END_CITY : "NORTH FORT MYERS",
                              END_STATE : "FL",
                              BILL_STATUS : "BILLD",
                              DETAIL_LINE_ID : 819474,
                              TX_TYPE : "D",
                              TYPE : "DELIVERY",
                              PIECES : "4",
                              PALLETS : "12.00",
                              WEIGHT : "10000",
                              PICKUP_BY : "08/13/2021",
                              DELIVER_BY : "08/19/2021",
                              DESTNAME : "UHAUL 830025",
                              ORIGNAME : "UHAUL",
                              DESTPHONE : "(239) 567-9179",
                              PICKUP_DONE : "True",
                              DELIVERY_DONE : "True",
                              ADDRESS_ORIGIN : "8400 N ALLEN RD , PEORIA , IL ,61615",
                              ORIGPC : "61615",
                              ADDRESS_DESTINE : "16901 N CLEVELAND AVE , NORTH FORT MYERS ,  FL , 33903",
                              DESTPC : "33903",
                              TEMP_CONTROLLED : "False",
                              TEMPERATURE : "",
                              ISSURVEY : true,
                              fotos : []
                                 )
                             ]
        )
    ]
}
