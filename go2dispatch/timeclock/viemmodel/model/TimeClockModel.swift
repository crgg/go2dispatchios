//
//  TimeClockModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/28/21.
//

import Foundation


struct lastTimeClockResponse : Codable {
    var status : Bool
    var data : TimeLogModel?
    var msg : String?
    enum CodingKeys: String, CodingKey {
        case status
        case data
        case msg
    }
}

struct TimeLogModel : Codable {
    
    var ID : Int?
    var START_DATE : String?
    var END_DATE : String?
    var START_LOC : String?
    var END_LOC : String?
    
}
struct TimeHistoryResponse  : Codable {
    var status :Bool
    var data : [TimeLogHistory]
    var time_zone : String?
    var msg : String?
    enum CodingKeys : String, CodingKey {
        case status
        case msg
        case data
        case time_zone
    }
    
    
}
struct TimeLogHistory : Codable {
    var SHIFT_ID : Int?
    var SHIFT_DATE : String?
    var data : [TimeLogModelHistory]?
    var TOTALHOURS :String?
    var TOTALHOURS_TIME_FORMAT : String?

    
    enum CodingKeys : String, CodingKey {
        case SHIFT_ID
        case SHIFT_DATE
        case data
        case TOTALHOURS
        case TOTALHOURS_TIME_FORMAT
        
    }
    
    init() {
         SHIFT_ID  = 1
        SHIFT_DATE = "02/05/2021"
         data =  [TimeLogModelHistory()]
         TOTALHOURS = "45.0"
    
         TOTALHOURS_TIME_FORMAT = "78.57"
    }
    
    init(from decoder : Decoder) throws {
    
        let values = try decoder.container(keyedBy: CodingKeys.self)
        SHIFT_ID = try? values.decode(Int.self, forKey: .SHIFT_ID)
        if let d = SHIFT_ID {
            SHIFT_ID = d
        }
        SHIFT_DATE = try? values.decode(String.self, forKey: .SHIFT_DATE)
        if  let d = SHIFT_DATE {
            SHIFT_DATE = d
        }
        
        data =  try? values.decode([TimeLogModelHistory].self, forKey: .data)
        if let d = data {
            data = d
        }
        
        TOTALHOURS =  try? values.decode(String.self, forKey: .TOTALHOURS)
        if let d = TOTALHOURS {
            TOTALHOURS = d
        }
        
        TOTALHOURS_TIME_FORMAT = try? values.decode(String.self, forKey:  .TOTALHOURS_TIME_FORMAT)
        if let d = TOTALHOURS_TIME_FORMAT {
            TOTALHOURS_TIME_FORMAT = d
        }
    }
}




struct TimeLogModelHistory : Codable {
    
    
    var ID : Int?
    var SHIFT_ID :Int?
    var SHIFT_DATE : String?
    var SHIFT_TYPE :String?
    var RES_TYPE : String?
    var RES_ID : String?
    var PAY_TYPE : String?
    var START_DATE : String?
    var START_LOC : String?
    var END_DATE : String?
    var END_LOC : String?
    var APPROVED : String?
    var APPROVED_BY : String?
    var APPROVED_DATE : String?
    var CREATED_BY : String?
    var HRS : String?
    var UPDATED_BY : String?
    var FORMATED_SHIFT_DATE : String?
    var FORMATED_START_DATE : String?
    var FORMATED_END_DATE : String?
    var FORMATED_APPROVED_DATE: String?

    enum CodingKeys : String, CodingKey {
        case ID
        case SHIFT_ID
        case SHIFT_DATE
        case SHIFT_TYPE
        case RES_TYPE
        case RES_ID
        case PAY_TYPE
        case START_DATE
        case START_LOC
        case END_DATE
        case END_LOC
        case APPROVED
        case APPROVED_BY
        case APPROVED_DATE
        case CREATED_BY
        case HRS
        case UPDATED_BY
        case FORMATED_SHIFT_DATE
        case FORMATED_START_DATE
        case FORMATED_END_DATE
        case FORMATED_APPROVED_DATE
         
        
    }
  
    init() {
        ID = 0
        SHIFT_ID = 0
        SHIFT_DATE = "03/25/2021"
        SHIFT_TYPE = "Regular"
        RES_TYPE = "D"
        RES_ID = "D"
        PAY_TYPE = ""
        START_DATE = "03/25/2021 03:01:45"
        START_LOC = ""
        END_DATE = "03/25/2021 03:20:45"
        END_LOC = ""
        APPROVED = ""
        APPROVED_BY = ""
        APPROVED_DATE = ""
        CREATED_BY = ""
        HRS = ""
        UPDATED_BY = ""
        FORMATED_SHIFT_DATE = ""
        FORMATED_START_DATE = ""
        FORMATED_END_DATE = ""
        FORMATED_APPROVED_DATE = ""
    }
    
 init(from decoder : Decoder) throws {
    
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try? values.decode(Int.self, forKey: .ID)
        if let d = ID {
            ID = d
        } else {
            ID = 0
        }
        SHIFT_ID = try? values.decode(Int.self, forKey: .SHIFT_ID)
        if let d = SHIFT_ID {
            SHIFT_ID = d
        } else {
            SHIFT_ID = 0
        }
        
        SHIFT_DATE = try? values.decode(String.self, forKey: .START_DATE)
        if let d = SHIFT_DATE {
            SHIFT_DATE = d
        } else {
            SHIFT_DATE = "none"
        }
                
        SHIFT_TYPE = try? values.decode(String.self, forKey: .SHIFT_TYPE)
        if let d = SHIFT_TYPE {
            SHIFT_TYPE = d
        } else {
            SHIFT_TYPE = "none"
        }
        
        RES_TYPE = try? values.decode(String.self, forKey: .RES_TYPE)
        if let d = RES_TYPE {
            RES_TYPE = d
        }
        RES_ID = try? values.decode(String.self, forKey: .RES_ID)
        if let d = RES_ID {
            RES_ID = d
        }
        PAY_TYPE = try? values.decode(String.self, forKey: .PAY_TYPE)
        if let d = PAY_TYPE {
            PAY_TYPE = d
        }
        START_DATE = try? values.decode(String.self, forKey: .START_DATE)
        if let d = START_DATE {
            START_DATE = d
        }
        START_LOC = try? values.decode(String.self, forKey: .START_LOC)
        if let d = START_LOC {
            START_LOC = d
        }
        END_DATE = try? values.decode(String.self, forKey: .END_DATE)
        if let d = END_DATE {
            END_DATE = d
        }
        END_LOC = try? values.decode(String.self, forKey: .END_LOC)
        if let d = END_LOC {
            END_LOC = d
        }
        APPROVED = try? values.decode(String.self, forKey: .APPROVED)
        if let d = APPROVED {
            APPROVED = d
        }
        APPROVED_BY = try? values.decode(String.self, forKey: .APPROVED_BY)
        if let d = APPROVED_BY {
            APPROVED_BY = d
        }
        APPROVED_DATE = try? values.decode(String.self, forKey: .APPROVED_DATE)
        if let d = APPROVED_DATE {
            APPROVED_DATE = d
        }
        CREATED_BY = try? values.decode(String.self, forKey: .CREATED_BY)
        if let d = CREATED_BY {
            CREATED_BY = d
        }
        HRS = try? values.decode(String.self, forKey: .HRS)
        if let d = HRS {
            HRS = d
        }
        UPDATED_BY = try? values.decode(String.self, forKey: .UPDATED_BY)
        if let d = UPDATED_BY {
            UPDATED_BY = d
        }
        FORMATED_SHIFT_DATE = try? values.decode(String.self, forKey: .FORMATED_SHIFT_DATE)
        if let d = FORMATED_SHIFT_DATE {
            FORMATED_SHIFT_DATE = d
        }
        FORMATED_START_DATE = try? values.decode(String.self, forKey: .FORMATED_START_DATE)
        if let d = FORMATED_START_DATE {
            FORMATED_START_DATE = d
        }
        FORMATED_END_DATE = try? values.decode(String.self, forKey: .SHIFT_ID)
        if let d = SHIFT_DATE {
            SHIFT_DATE = d
        }
        FORMATED_APPROVED_DATE = try? values.decode(String.self, forKey: .FORMATED_APPROVED_DATE)
        if let d = FORMATED_APPROVED_DATE {
            FORMATED_APPROVED_DATE = d
        }
        
      

    }
    
    
}

struct DispatchClockResponse : Codable {
    var status : Bool?
    var msg : String?
    var question : Bool?
    var can_clock_in : Bool?
    
    enum CodingKeys : String, CodingKey {
        case status
        case msg
        case question
        case can_clock_in
        
        
    }
    
    
    init(from decoder : Decoder) throws {
    
        let values = try decoder.container(keyedBy: CodingKeys.self)
        question = try? values.decode(Bool.self, forKey: .question)
        if let d = question {
            question = d
        
        }
        msg = try? values.decode(String.self, forKey: .msg)
        if let m = msg {
            msg = m
        }
        status  = try? values.decode(Bool.self, forKey: .status)
        if let s = status {
            status = s
        }
        
    }

}
