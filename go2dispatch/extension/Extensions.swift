//
//  Extensions.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/27/21.
//

import Foundation
import SwiftUI
enum UserDefaultsKeys : String {
    case userData
    case name
    case phone
    case isVeryCode
    case isLoggedIn
    case deviceToken
    case intervalPosition
    case loginTrip
    
    
}
  
extension UserDefaults {
    func setDeviceToken(_ value: String) {
        set(value, forKey: UserDefaultsKeys.deviceToken.rawValue)
    }
    func getDeviceToken() -> String {
        return object(forKey: UserDefaultsKeys.deviceToken.rawValue) as? String ?? ""
    }
    //MARK: Check Login
    func setLoggedIn(_ value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }
    
    func getLoggedIn() -> Bool {
        return object(forKey:  UserDefaultsKeys.isLoggedIn.rawValue) as? Bool ?? false
        //synchronize()
    }
    
    
    
    func setVeryCode(_ value : Bool) {
        set(value, forKey: UserDefaultsKeys.isVeryCode.rawValue)
    }
    
    func getVeryCode() -> Bool {
        return object(forKey: UserDefaultsKeys.isVeryCode.rawValue) as? Bool ?? false
    }
    
    func setUserData(_ value: UserModel) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: UserDefaultsKeys.userData.rawValue)
    }
    
    func getUserData() -> UserModel? {        
        if let datauser = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData.rawValue) {
            let datauser_result =  try? PropertyListDecoder().decode(UserModel.self, from: datauser)
                return datauser_result
        }
        return nil
    }
    
    func getApiToken() -> String? {
        if let datauser = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData.rawValue) {
            let datauser_result =  try? PropertyListDecoder().decode(UserModel.self, from: datauser)
            if let apitoken = datauser_result?.apiToken {
                    return apitoken
            }
        }
        return nil
    }
    
    // get usernem
    
    func getUserName() -> String? {
        if let datauser = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData.rawValue) {
            let datauser_result =  try? PropertyListDecoder().decode(UserModel.self, from: datauser)
            if let username = datauser_result?.user.name {
                    return username
            }
        }
        return nil
    }
    
    
    func clearUserDefaults(){
        removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    func removeValuefromUserdefault(Key:String){
        removeObject(forKey: Key)
    }
    
    
}
extension String  {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPasswor : Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    
    
}

// Placeholder

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension URLRequest {
    
    init(_ urlctm: URL) {
               self.init(url: urlctm)
               self.setValue("application/json", forHTTPHeaderField: "Content-Type")
               self.setValue("application/json", forHTTPHeaderField: "Accept")
               
        
           }
    
    
    init(_ url: URL, apiToken: String) {
               self.init(url: url)
               self.setValue("application/json", forHTTPHeaderField: "Content-Type")
               self.setValue("application/json", forHTTPHeaderField: "Accept")
               self.setValue("Bearer \(apiToken)", forHTTPHeaderField:"Authorization" )
        
           }
    
}

