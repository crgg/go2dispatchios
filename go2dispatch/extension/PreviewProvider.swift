//
//  PreviewProvider.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/17/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
    
}

class DeveloperPreview {
    static let instance  =  DeveloperPreview()
    
    private init()  {}
    
    let customers = [
        CustomerModel(
                   NAME: "CHR CHATTANO OGA",
                   CLIENT_ID: "1197BV",
                   ADDRESS_1: "1206 POINTE CENTER DR",
                   ADDRESS_2 : "",
                   CITY : "CHATTANOOGA",
                   PROVINCE : "TN",
                   POSTAL_CODE : "37421",
                   BUSINESS_PHONE : "423 296 2801",
                   EMAIL_ADDRESS : "PAYNJASO@CHROBINSON.COM",
                   SALES_REP : "JERRYZ",
                   CONTACT : "JASON PAYNE",
                   CLIENT_IS_CALLER : "True ",
                   CLIENT_IS_CONSIGNEE : "False",
                   CLIENT_IS_SHIPPER : "False",
                   COUNTRY : "  "
        ),
        CustomerModel(
        
              NAME : "Optimal Performance, LLC",
              CLIENT_ID : "128792",
              ADDRESS_1 : "OPTIMAL PERFORMANCE, LLC",
              ADDRESS_2 : "1853 SUNCAST LANE ",
              CITY : "BATAVIA",
              PROVINCE : "IL",
              POSTAL_CODE : "60510",
              BUSINESS_PHONE: "",
              EMAIL_ADDRESS: "",
              SALES_REP : "",
              CONTACT : "",
              CLIENT_IS_CALLER : "True ",
              CLIENT_IS_CONSIGNEE : "True ",
              CLIENT_IS_SHIPPER : "True ",
              COUNTRY : ""
        )
        
      ]
}

