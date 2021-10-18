//
//  SaveData.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import Foundation
class SaveData {
    var correo : String = ""
    var password : String = ""
    var name : String = ""
    
     
    func save(corre: String, password : String , name: String ) -> Bool {
        
        print("Dentro guardar datos \(correo) + \(password) + \(name)")
        
        UserDefaults.standard.set([correo,password, name], forKey: " ")
        return true
    }
    
    func recoverData() -> [String] {
        let datauser: [String] = UserDefaults.standard.stringArray(forKey: "userdata")!
        print("recover data user is  \(datauser)")
        
        return datauser
        
    }
    
    func validarData(correo: String, password : String ) -> Bool {
        
        var correoSave = ""
        var passwordSave = ""
        
        print("Revisando si tengo datos en user defualts con el correo \(correo) y la password \(password)")
        
        
        if UserDefaults.standard.object(forKey: "userdata") != nil {
            correoSave = UserDefaults.standard.stringArray(forKey: "userdata")![0]
            passwordSave = UserDefaults.standard.stringArray(forKey: "userdata")![1]
            print("El correo is \(correoSave) and password \(correoSave)" )
            if (correo == correoSave && password == passwordSave) {
                return true
            } else {
                return false
            }
             
            
        } else {
            print("noting")
            return false
        }
        
        
        
        
    }
}

