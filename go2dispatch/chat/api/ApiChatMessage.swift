//
//  apiChatMessage.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/9/21.
//

import Foundation
extension ApiChat {
    
    
    static func markAllReaded(session_id : Int, to_user: String, trip_number: Int) {
        
        guard  session_id > 0 else {
            print(" MarkAllReaded error session id is 0")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" falta el user id")
            return
        }
        
        let urlString = "\(ApiConfig.READ_AT)"
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
            
            do {
                               
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(MessageRequest.self , from : jsonData)
                   
                    guard decodeData.status else {
                        print("error markAllReaded")
                        return
                    }
                    print("update all readed success")
                    
                    return
                }
            } catch let err {
                print(err)
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
           
            
        }.resume()
        
        

        
        
    }
    
    static func insertMessage(msg : String , chat : Chat, handler: @escaping (_ sucess : Bool, _ error : String?, _ result : DataMessageRequest? )->()) {
        
        let driverid = chat.person.driver_id
        guard  chat.session_id > 0 else {
            print(" ✏️ chatRoom: SEND_MESSAGE : Session is Null")
            return
        }
        guard let username = UserDefaults.standard.getUserData()?.user.username  else {
            print(" ✏️ Error the username internal")
            return
        }
        
        let urlString = "\(ApiConfig.SEND_MESSAGE)/\(chat.session_id )"
        
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
                            "UUID" : chat.messages.last?.id.uuidString ?? UUID().uuidString,
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
        
        let urlString = "\(ApiConfig.URL_PROD)\(ApiConfig.RETURN_MESSAGES)/\(session_id)/chats"
        
        guard let url = URL(string: urlString) else {
            print("error the url conform")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let apiToken = UserDefaults.standard.getApiToken()
        
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
                    
                    let chat_data : Chata_data = Chata_data()
                    DispatchQueue.main.async {
                        chat_data.saveMessages(decodeData.data)
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
    
}
