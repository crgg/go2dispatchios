//
//  ApiChat.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/1/21.
//

import Foundation


class ApiChat {
    
    static func getUsers(handler: @escaping (_ sucess : Bool, _ error : String?, [driver_users])->()) {
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_DRIVER_LIST)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let apiToken = UserDefaults.standard.getApiToken()
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(DriverUsers.self , from : jsonData)
                    print(decodeData.data.first ?? "")
                    handler(true, "success", decodeData.data)
                    
                    DispatchQueue.main.async {
                        ChatDataManager.instance.save_users(driver_users: decodeData.data)
                    }
                    
                    
                    
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
                        handler(false, errorCtm.msg, [])
                        return
                    }
                }
                handler(false, err.localizedDescription, [])
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error", [])
            
        }.resume()
    }
    
    static func getAllUsers(handler: @escaping (_ sucess : Bool, _ error : String?, [driver_users])->()) {
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_DRIVER_LIST_WITH_IMAGES)"
        
        guard  let url = URL(string: urlString) else { return  }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let apiToken = UserDefaults.standard.getApiToken()
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(AllDriverUsers.self , from : jsonData)
                    print(decodeData.data.first ?? "")
                    
                    
                    
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
                        handler(false, errorCtm.msg, [])
                        return
                    }
                }
                handler(false, err.localizedDescription, [])
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error", [])
            
        }.resume()
    }
    
    
    static func createSession(driver_id: String, trip_number : Int,    handler: @escaping(_ sucess : Bool, _ error : String?,_ result : Int? )->()) {
        
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" falta el user id")
            handler(false, "Error missing username", nil)
            return
        }
        
        let urlString = "\(ApiConfig.CREATE_SESSION)"
        
        guard let url = URL(string: urlString) else {
            print("error the url conform")
            handler(false, "Error create url", nil)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let param = ["user" : username  ,
                      "trip":  String(trip_number),
                      "driver": driver_id ]
        
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
            handler(false, "Error the parameters", nil)
            return
        }
        request.httpBody =  jsonParam
        let apiToken = UserDefaults.standard.getApiToken()
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(CreateSessionRequest.self , from : jsonData)
                   
                    guard decodeData.status else {
                        print("error markAllReaded")
                        handler(false, "Error request try again later", nil)
                        return
                    }
                    print("update all readed success \(decodeData.sessionid)")
                    handler(true,nil, decodeData.sessionid)
                    return
                }
            } catch let err {
                print(err)
                handler(false, "Error data received", nil)
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, "unknow error", nil)
           
            
        }.resume()
        
        
        
    }
    
}
