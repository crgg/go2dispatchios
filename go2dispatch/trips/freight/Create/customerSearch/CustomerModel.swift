//
//  CustomerModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 1/12/22.
//

import Foundation

struct customerReceived : Codable {
    
    let data : [CustomerModel]
}


struct CustomerModel : Codable, Identifiable {
    var id : String {CLIENT_ID}
    var NAME : String?
    var CLIENT_ID : String
    var ADDRESS_1 : String?
    var ADDRESS_2 : String?
    var CITY : String?
    var PROVINCE : String?
    var POSTAL_CODE : String?
    var BUSINESS_PHONE : String?
    var EMAIL_ADDRESS : String?
    var SALES_REP : String?
    var CONTACT : String?
    var CLIENT_IS_CALLER : String?
    var CLIENT_IS_CONSIGNEE : String?
    var CLIENT_IS_SHIPPER : String?
    var COUNTRY : String?
    var selected : String?

    // esto es un test
    func updateSelected(selected : String) -> CustomerModel {
        return CustomerModel( NAME: NAME, CLIENT_ID: CLIENT_ID, ADDRESS_1: ADDRESS_1, ADDRESS_2: ADDRESS_2, CITY: CITY, PROVINCE: PROVINCE, POSTAL_CODE: POSTAL_CODE, BUSINESS_PHONE: BUSINESS_PHONE, EMAIL_ADDRESS: EMAIL_ADDRESS, SALES_REP: SALES_REP, CONTACT: CONTACT, CLIENT_IS_CALLER: CLIENT_IS_CALLER, CLIENT_IS_CONSIGNEE: CLIENT_IS_CONSIGNEE, CLIENT_IS_SHIPPER: CLIENT_IS_SHIPPER, COUNTRY: COUNTRY, selected: selected)
    }
    
    
    
}

enum typeCustomer : String {
    case caller = "caller"
    case shipper = "shipper"
    case consignee = "consignee"
    case pickup = "PICKUP"
    
}
