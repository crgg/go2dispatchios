//
//  UserModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/26/21.
//

import Foundation

 


// MARK: - UserModel
struct UserModel: Codable {
    let status: Bool
    let apiToken: String
    let user: User
   
    enum CodingKeys: String, CodingKey {
        case status
        case apiToken = "api_token"
        case user
        
    }
}

// MARK: - User
struct User: Codable {
    var id: Int
    var name, email,  username : String
    var profilePicture : String?
    var phone_number: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case profilePicture = "profile_picture"
        case username
        case phone_number
    }
}


struct UserModelError: Codable {
    let status: Bool
    let msg: String
}
