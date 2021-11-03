//
//  LoginModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import Foundation
class LoginViewModel   {
    
    static func login(email: String , password : String,  handler: @escaping (_ sucess : Bool, _ error : String?)->()) {
         
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_LOGIN)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url)
        
        request.httpMethod = "POST"
        
        var deviceToken =  UserDefaults.standard.getDeviceToken()
        
        if deviceToken.isEmpty {
            deviceToken = "none"
            
        }
   
        let param =  ["email" : email, "password" : password, "device_token" : deviceToken ]
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
            return
        }
        
//        let postString = "PHONE_DATETIME=\(dateString)&LOCATION=\(location_address)"
        
        request.httpBody =  jsonParam
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(UserModel.self , from : jsonData)
                    UserDefaults.standard.setLoggedIn(true)
                    UserDefaults.standard.setUserData(decodeData)
                    
                    handler(true, "success")
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
                        handler(false, errorCtm.msg)
                        return
                    }
                }
                handler(false, err.localizedDescription)
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error")
            
        }.resume()
        
    }
    
    static func registration_sms(email: String, password: String, phone_number : String ,  Image : Data?, handler: @escaping (_ success: Bool , _ error: String?) -> ()) {
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_REGISTRATION_SMS)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
 
      //  let deviceToken =  UserDefaults.standard.getDeviceToken()
        
        let postString = "email=\(email)&password=\(password)&repassword=\(password)&phone_number=\(phone_number)"
        
        request.httpBody =  postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let jsonData = data  {
                let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let status =  responseJSON["status"] as? Bool {
                        if !status {
                            if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                                print(errorCtm.msg)
                                handler(false, errorCtm.msg)
                                return
                            }
                        } else {
                            // pass and send the code via sms
                            
                             let userdata = User(id: 0, name: "", email: email, username: "", profilePicture: "", phone_number: phone_number)
                            
                             let usermodel = UserModel(status: false, apiToken: "", user: userdata)
                          
                            UserDefaults.standard.setUserData(usermodel)
                            handler(true, nil)
                            return
                        }
                    }
                }
              
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error")
        }.resume()
        
    }
    
    
    static func validateCode(email: String, code : String, handler: @escaping (_ success: Bool , _ error: String?) -> ()) {
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_VALIDATE_CODE)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let postString = "email=\(email)&register_code=\(code)"
        
        request.httpBody =  postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let jsonData = data  {
                let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let status =  responseJSON["status"] as? Bool {
                        if !status {
                            if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                                print(errorCtm.msg)
                                handler(false, errorCtm.msg)
                                return
                            }
                        }
                    }
                }
                do {
                    let decodeData = try JSONDecoder().decode(UserModel.self , from : jsonData)
                    UserDefaults.standard.setUserData(decodeData)
                    handler(true, "success")
                    return
                } catch let err {
                    handler(false, err.localizedDescription)
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error")
        }.resume()
        
    }
    
    
    static func resend_code(email: String, handler: @escaping (_ success: Bool , _ error: String?) -> ()) {
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.URL_CODE_RESEND)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let postString = "email=\(email)"
        
        request.httpBody =  postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let jsonData = data  {
                let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let status =  responseJSON["status"] as? Bool {
                        if !status {
                            if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                                print(errorCtm.msg)
                                handler(false, errorCtm.msg)
                                return
                            }
                        } else {
                            handler(true, nil)
                        }
                    }
                }
//                do {
//                    let decodeData = try JSONDecoder().decode(UserModel.self , from : jsonData)
//                    UserDefaults.standard.setUserData(decodeData)
//                    handler(true, "success")
//                    return
//                } catch let err {
//                    handler(false, err.localizedDescription)
//                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            handler(false, error?.localizedDescription ?? "Unknown error")
        }.resume()
        
    }
    
    
}


