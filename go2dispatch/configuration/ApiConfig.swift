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
    public static let URL_CHAT_API : String = "https://driverapp.tech4tms.com/api/chat_api/"
    
    public static let URL_LOGIN : String  =  "dispatcher_login"
    
    public static let URL_REGISTRATION : String = "dispatcher_register"
    
    public static let URL_REGISTRATION_SMS : String = "dispatcher_register_sms"
    
    public static let URL_DRIVER_LIST : String  =  "driver_trip_list" // Only open chat
    
    public static let URL_DRIVER_LIST_WITH_IMAGES = "return_driver_list_images_url"
    
    public static let URL_VALIDATE_CODE : String  = "validate_dispatch_code"
    
    public static let URL_CODE_RESEND : String = "resend_code"
    
    // Time clock urls
    public static let LAST_TIME_CLOCK : String = "last_time_clock"
    
    public static let GET_LATEST_CLOCK_IN : String = "get_latest_clock_in"
    
    public static let DISPATCHER_CLOCK : String = "dispatcher_clock"
    
    public static let RETURN_MESSAGES : String = "session"
    
    public static let SEND_MESSAGE : String = "\(URL_CHAT_API)send"
    
    
    
}
