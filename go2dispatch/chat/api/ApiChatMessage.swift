//
//  apiChatMessage.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
import Alamofire

typealias Parameters = [String: String]
extension ApiChat {
    
    
    static func readMessage(session_id: Int, message_id : Int) {
//        // message: '33',
//            // message_id: 10507,
//            // uuid: '60019E47-5CB4-457E-A09D-67E203BAEB79',
//            // user: 'RAMON',
//            // session_id: 274,
//            // wherefrom: 'PHONE'
//
//            controllerMessages.readatByMessageId(msg.session_id, msg.message_id);
        
        guard  session_id > 0 else {
            print(" MarkAllReaded error session id is 0")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" falta el user id")
            return
        }
        
        let urlString = "\(ApiConfig.URL_CHAT)/message/readatByMessageId"
      
        guard let url = URL(string: urlString) else {
            print("error the url conform")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.000000"
//        let dateString =  String(dateFormatterGet.string(from: Date()))
//
        let param = ["session_id" : String(session_id) ,
                     "message_id" : String(message_id)]
        
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
            return
        }
        request.httpBody =  jsonParam
        let apiToken = UserDefaults.standard.getApiToken()
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            
  
                if let jsonData = data {
                    // extra for know what is comming
                    let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if let status = responseJSON["status"] as? Bool {
                            if status {
                                return
                            } else {
                                print("error")
                            }
                        }
                        
                    }
                    if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                        print(errorCtm.msg)
//                        handler(false, errorCtm.msg, nil)
                        return
                    }
                }
                
                
            
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
           
            
        }.resume()
        
        
        
    }
    
    static func markAllReaded(session_id : Int, to_user: String, trip_number: Int) {
        
        guard  session_id > 0 else {
            print(" MarkAllReaded error session id is 0")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" falta el user id")
            return
        }
        
        let urlString = "\(ApiConfig.URL_CHAT)/message/readat"
      
        guard let url = URL(string: urlString) else {
            print("error the url conform")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.000000"
//        let dateString =  String(dateFormatterGet.string(from: Date()))
//
        let param = ["session_id" : String(session_id) ,
                      "trip":  String(trip_number),
                      "to_user": to_user,
                      "user_send" : username]
        
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
            return
        }
        request.httpBody =  jsonParam
        let apiToken = UserDefaults.standard.getApiToken()
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            
  
                if let jsonData = data {
                    // extra for know what is comming
                    let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if let status = responseJSON["status"] as? Bool {
                            if status {
                                return
                            } else {
                                print("error")
                            }
                        }
                        
                    }
                    if let errorCtm = try? JSONDecoder().decode(UserModelError.self, from: jsonData) {
                        print(errorCtm.msg)
//                        handler(false, errorCtm.msg, nil)
                        return
                    }
                }
                
                
            
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
           
            
        }.resume()
        
        

        
        
    }
    
    static func insertMessage(msg : String , chat : Chat ,handler: @escaping (_ sucess : Bool, _ error : String?, _ result : DataMessageRequest? )->()) {
        
        
        
        let driverid = chat.person.driver_id
        guard  chat.session_id > 0 else {
            print(" ✏️ chatRoom: SEND_MESSAGE : Session is Null")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" ✏️ Error the username internal")
            return
        }
        guard !msg.isEmpty else {
            print(" 🚨 Message viene empty")
            return
        }
        
        let urlString2 = "\(ApiConfig.SEND_MESSAGE)/\(chat.session_id )"
        let urlString = "http://localhost:3001/message/add"
        
        guard let url = URL(string: urlString) else {
            print("error the url conform")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.000000"
        let dateString =  String(dateFormatterGet.string(from: Date()))
        
                    let param = [
                            "session_id" : String(chat.session_id) ,
                            "trip":  "0",
                            "to_user": driverid,
                            "user_send": username,
                            "driver" : driverid,
                            "user" : username,
                            "message": msg,
                            "content" : msg,
                            "date": dateString,
                            "UUID" : UUID().uuidString,
                            "url" : urlString2,
                        ]
        
        
        guard let jsonParam = try? JSONEncoder().encode(param) else {
            print("error the parameters")
            return
        }
        
//        let postString = "PHONE_DATETIME=\(dateString)&LOCATION=\(location_address)"
        
        request.httpBody =  jsonParam
        
        
        let apiToken = UserDefaults.standard.getApiToken()
        
        
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
        
         
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(MessageRequest.self , from : jsonData)
                   
                    guard decodeData.status else {
                        handler(true,"No found Message", nil)
                        return
                    }
                    handler(true,nil,decodeData.data)
                   
                    
                    
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
    
    
    static func getMessages(session_id: Int, handler: @escaping (_ sucess : Bool, _ error : String?, [MessagesList])->()) {
        
        guard  session_id > 0 else {
            handler(false, "Error Session id is 0", [] )
            return

        }
        guard let username = UserDefaults.standard.getUserData()?.user.username else {
            handler(false, "Error username pleae log out the app", [] )
            return
        }
        
//        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.RETURN_MESSAGES)/\(session_id)/chats"
        let urlString = "http://localhost:3001/message"
        
        guard var url = URLComponents(string: urlString) else {
            print("error the url conform")
            return
        }
        
        let apiToken = UserDefaults.standard.getApiToken()
        url.queryItems = [ URLQueryItem(name: "session_id", value: String(session_id)),
                           URLQueryItem(name: "api_token", value: apiToken ?? "")
                            
                            ]
        
        var request = URLRequest(url: url.url!)
        
        request.httpMethod = "GET"
        
        
        
       
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiToken ?? "", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(MessagesReceived.self , from : jsonData)
                    print(decodeData.data.first ?? "")
                    guard decodeData.status else {
                        handler(true,"No found Message", [])
                        return
                    }
                    
                    
                    DispatchQueue.main.async {
                        ChatDataManager.instance.saveMessages(decodeData.data)
                    }
                            
                   let datar = decodeData.data.sorted(by: {$0.id < $1.id})
                    handler(true, "success", datar)
                    
                    
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

    
    static func sendMedia(msg : String , chat : Chat, image_data : Data?, handler: @escaping (_ sucess : Bool, _ error : String?, _ result : sendDataModel? )->()) {
        
        
        guard  chat.session_id > 0 else {
            print(" ✏️ chatRoom: SEND_MESSAGE : Session is Null")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" ✏️ Error the username internal")
            return
        }
        guard !msg.isEmpty else {
            print(" 🚨 Message viene empty")
            return
        }
        let driverid = chat.person.driver_id
        
        let urlString2 = "\(ApiConfig.SEND_MEDIA)"
        let urlString = "http://localhost:3001/message/media"
//        let urlString =  urlString2
        
        
        guard let url = URL(string: urlString) else {
            print("error the url conform")
            return
        }
        
      
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss.000000"
        let dateString =  String(dateFormatterGet.string(from: Date()))
        
                    let params = [
                            "session_id" : String(chat.session_id) ,
                            "session" : String(chat.session_id) ,
                            "trip":  "0",
                            "to_user": driverid,
                            "user_send": username,
                            "username" : username,
                            "driver" : driverid,
                            "user" : username,
                            "message": msg,
                            "content" : msg,
                            "date": dateString,
                            "UUID" : chat.messages.last?.id.uuidString ?? UUID().uuidString,
                            "url" : urlString2,
                            
                        ]
        
        
//        guard let jsonParam = try? JSONEncoder().encode(params) else {
//            print("error the parameters")
//            return
//        }
        let apiToken = UserDefaults.standard.getApiToken()
        let headers : HTTPHeaders =   [ "Authorization" : "Bearer \(apiToken ?? "")",
                         "Content-Type" : "application/json",
                         "Content-type": "multipart/form-data",
                         "Accept" : "application/json"]
        
        print("🤳 initial upload photo ")
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
          
                if let avatarData = image_data {
                    multipartFormData.append(avatarData, withName: "file", fileName: "\(arc4random()).jpg", mimeType: "image/png")
                }
        }, to: urlString, usingThreshold: UInt64.init(),  method: .post, headers: headers)
            .responseDecodable(of: sendDataReceivedResponse.self ) { (response) in
                switch response.result {
                case .success(let value):
                    if let datos =  value.data {
                        print("🤳 data Received \(datos.user ?? "") url : \(datos.message ?? "")")
                        handler(true, nil, datos)
                    } else {
                        print("🤳 error received the data")
                        handler(false, "Error unknow please try again later", nil)
                    }
                case .failure(let error):
                    print("🤳 \(error)")
                    handler(false, "Error unknow please try again later", nil)
                }
            }
    }
    
    
//    Handling event: chat with data: [{
//        UUID = "46BABAFE-00E9-4915-AC4B-DF63665752C3";
//        content = image;
//        date = "2022-01-04 17:45:11.000000";
//        driver = RAMON;
//        id = 10994;
//        message = "https://go2storage.s3.us-east-2.amazonaws.com/DRIVER_CHAT_TEST/CHATS/311/2022/01/311_33.png";
//        "session_id" = 311;
//        "to_user" = RAMON;
//        trip = 0;
//        type = 1;
//        user = RAMON;
//        "user_send" = RAMON;
//        where = WEB;
//
    
  static  func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }
    
 
}
struct sendDataReceivedResponse : Codable {
    let status : Bool
    let data : sendDataModel?
    let msg : String?
    
}

struct sendDataModel : Codable {
    var id : Int?
    var date : String?
    var driver : String?
    var message : String?
    var trip: String?
    var type : Int?
    var user : String?
    var send_at : send_at?
    var session_id : Int?
    var url : String?
    var uuid : UUID?
    var status : String?
    var content : String?
    var wherefrom: String?
    
}
struct send_at : Codable {
    var date : String?
}
