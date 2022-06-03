//
//  ApiConfig.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import Foundation

import Alamofire
class ApiConfig {
    
//    public static let URL_DEMO : String =  "http://apptest.goto-logistics.com/driverapi/api/"
//    public static let URL_PROD : String =  "https://driverapp.goto-logistics.com/api/Shoprest/"
    
    public static let URL_PROD : String =  "https://driverapp.tech4tms.com/api/dispatcher_app/"
    
    public static let URL_CHAT : String = "http://3.15.5.85:3001/"
    
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
   
    public static let SEND_MEDIA : String  =  "\(URL_PROD)chat_save_file"
    
    public static let SEND_MESSAGE : String = "\(URL_CHAT_API)send"
   
    public static let READ_AT : String  = "\(URL_CHAT_API)read_at"
    
    public static let CREATE_SESSION : String  = "\(URL_CHAT_API)session/create"
    
//    let urlString = "http://localhost:3001/message/add"
    public static let message_add : String  = "\(URL_CHAT)message/add"
    
//    let urlString = "http://localhost:3001/message"
    public static let message_chat : String  = "\(URL_CHAT)message"
//  http://localhost:3001/message/media
    public static let message_media : String  = "\(URL_CHAT)message/media"
    
    // customers
    public static let TRIP_LIST_BY_TERMINAL = "\(URL_PROD)trip_list_by_terminal/"
    
    
    // trailer
    public static let TRAILER_LIST = "\(URL_PROD)trailers_active_list"
    
    
    
    public static let RETURN_SEARCH_LIST =  "\(URL_PROD)return_customers"
    public static let ASSIGN_TRAILER =  "\(URL_PROD)atach_trailer_to_trip"
    
    static let headers : HTTPHeaders =   [ "Authorization" : "Bearer \(UserDefaults.standard.getApiToken() ?? "")",
                         "Content-Type" : "application/json",
                         "Accept" : "application/json"] 
    
}
