//
//  UtilDate.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/13/21.
//

import Foundation
class UtilDate {
    
    static func parseDate(dateString : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat =   "yyyy-MM-dd HH:mm:ss.000000"
        formatter.locale = Locale(identifier: "en_us")
        return formatter.date(from: dateString)
    }
}
