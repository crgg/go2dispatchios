//
//  ApiTimeClock.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/28/21.
//

import Foundation


class ApiTimeClock {
    
    
    static func lastTimeClock(handler : @escaping (_ success : Bool, _ error: String?  , _ timeLogmodel : TimeLogModel? )->()) {
        
        let url = URL(string: "\(ApiConfig.URL_PROD)\(ApiConfig.LAST_TIME_CLOCK)")
        guard let url = url else {
            handler(false, "Error url", nil)
            return
            
        }
        let apiToken = UserDefaults.standard.getApiToken()
        
        var request = URLRequest(url, apiToken: apiToken ?? "" )
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(lastTimeClockResponse.self , from : jsonData)
                    handler(true, "success", decodeData.data)
                    return
                }
            } catch let err {
                print(err)
                if let jsonData = data {
                    // extra for know what is comming
                    let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                    if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                        print(errorCtm.msg)
                        handler(false, errorCtm.msg, nil)
                        return
                    }
                }
                handler(false, err.localizedDescription, nil)
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error", nil)
            
        }.resume()
       
        
        
  
    }
    
    static func HistoryTimeClock(handler : @escaping (_ success : Bool, _ error: String?  ,_ time_zone : String?,  _ timeLogmodel : [TimeLogHistory]?  )->()) {
        
        let url = URL(string: "\(ApiConfig.URL_PROD)\(ApiConfig.GET_LATEST_CLOCK_IN)")
        guard let url = url else {
            handler(false, "Error url", nil, nil)
            return
            
        }
        let apiToken = UserDefaults.standard.getApiToken()
        var request = URLRequest(url, apiToken: apiToken ?? "")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(TimeHistoryResponse.self , from : jsonData)
                    handler(true, nil, decodeData.time_zone, decodeData.data)
                    return
                }
            } catch let err {
                print(err)
                if let jsonData = data {
                    // extra for know what is comming
                    let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                    if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                        print(errorCtm.msg)
                        handler(false, errorCtm.msg, nil, nil)
                        return
                    }
                }
                handler(false, err.localizedDescription, nil, nil)
            }
            
            print("Failed HistoryTimeClock url : \(url.path) string:  \(error?.localizedDescription ?? "Unknown error")")
            
            
            handler(false, error?.localizedDescription ?? "Unknown error", nil, nil)
            
        }.resume()
       
        
        
  
    }
     
    
    static func pickTime(location_address: String, latitude: Double , Longitude : Double,
                         handler : @escaping (_ success:Bool, _ error: String? ,_  result: String? )->()) {
        
        let url = URL(string: "\(ApiConfig.URL_PROD)\(ApiConfig.DISPATCHER_CLOCK)")
        guard let url = url else {
            handler(false, "Error url", nil)
            return
            
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.000000"
        let dateString =  String(dateFormatterGet.string(from: Date()))
        
        let apiToken = UserDefaults.standard.getApiToken()
        var request = URLRequest(url, apiToken: apiToken ?? "")
        
        request.httpMethod = "POST"
        
        let param =  ["PHONE_DATETIME" : dateString, "LOCATION" : location_address]
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
            return
        }
        
//        let postString = "PHONE_DATETIME=\(dateString)&LOCATION=\(location_address)"
        
        request.httpBody =  jsonParam
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(DispatchClockResponse.self , from : jsonData)
                    guard let status = decodeData.status else {
                        handler(false,"error the status", nil)
                        return
                    }
                    guard status else {
                        if let msg = decodeData.msg  {
                            handler(false, msg, nil)
                            return
                        }
                        handler(false,"error the status", nil)
                        return
                    }
                    
                    handler(true, nil, "success")
                    return
                }
            } catch let err {
                print(err)
                if let jsonData = data {
                    // extra for know what is comming
                    let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                    if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                        print(errorCtm.msg)
                        handler(false, errorCtm.msg, nil)
                        return
                    }
                }
                handler(false, err.localizedDescription, nil)
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error", nil)
            
        }.resume()
       
        
        
    }
    
    
    static func getLocationAddress(handler : @escaping (_ msg : String?, _ addressLocation : String?, _ latitude: Double?,_ longitude : Double?)->()) {
        print("location tomada : getAddress")
        
        CurrentGps.get_location_and_address() {
            (error, result) in
            if let e = error {
                 handler(e,nil,nil,nil)
                return
            }
            if let r = result {
                guard let addresslocation = r.addressComplete else {
                    handler("no address", nil,nil,nil)
                    return
                }
                guard let latitude =  r.latitude else  {
                    handler("no latitude", nil,nil,nil)
                    return
                }
                guard let longitude =  r.longitude else  {
                    handler("no latitude", nil,nil,nil)
                    return
                }
                handler(nil, addresslocation, latitude, longitude)
            }
            
        }
    }
    
}
