//
//  ApiConfig.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import Foundation


class ApiConfig {
    
//    public static let URL_DEMO : String =  "http://apptest.goto-logistics.com/driverapi/api/"
//    public static let URL_PROD : String =  "https://driverapp.goto-logistics.com/api/Shoprest/"
    
    public static let URL_PROD : String =  "https://driverapp.tech4tms.com/api/dispatcher_app/"
    
    public static let URL_LOGIN : String  =  "dispatcher_login"
    
    public static let URL_REGISTRATION : String = "dispatcher_register"
    
    public static let URL_REGISTRATION_SMS : String = "dispatcher_register_sms"
    
    public static let URL_DRIVER_LIST : String  =  "driver_trip_list" // Only open chat
    
    public static let URL_DRIVER_LIST_WITH_IMAGES = "return_driver_list_images_url"
    
    public static let URL_VALIDATE_CODE : String  = "validate_dispatch_code"
    
    public static let URL_CODE_RESEND : String = "resend_code"
    
    
}