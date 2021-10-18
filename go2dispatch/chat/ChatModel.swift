//
//  ChatModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/29/21.
//

import Foundation
struct Chat: Identifiable {
    var id : UUID { person.id }
    let person : Person
    var messages: [Message]
    var hasUnreadMessage = false
    
    
}
struct Person: Identifiable {
    let id = UUID()
    let name : String
    let driver_id : String
    let imgString : String
}
struct Message : Identifiable {
    enum MessageType {
        case send
        case received
    }
    let id = UUID()
    let date : Date
    let text : String
    let type : MessageType
    init(_ text: String, type : MessageType, date: Date) {
        self.date = date
        self.type = type
        self.text = text
    }
    init(_ text: String, type: MessageType ) {
        self.init(text, type:type, date: Date())
    }
    
}

extension Chat {
    static let sampleChat = [
        Chat(person: Person(name: "Paulette Gajardo", driver_id:"Paulette", imgString: "Avatar Users2_1"), messages : [
            Message("Hey Paullete", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Yes Dale", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Aguante el Bullita", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Vamo con todo", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3))
        ], hasUnreadMessage: true),
        
        Chat(person: Person(name: "Raymond Gajardo", driver_id: "Raymond", imgString: "Avatar Users2_2"), messages : [
            Message("Hey Raymond", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 1)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 1))
            
            
        ], hasUnreadMessage: true),
        Chat(person: Person(name: "Paola Carvallo", driver_id: "Paola",  imgString: "Avatar Users2_3"), messages : [
            Message("Hey Paola", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 1))
            
            
        ], hasUnreadMessage: false),
        Chat(person: Person(name: "Ramon Gajardo", driver_id: "Ramon", imgString: "Avatar Users2_4"), messages : [
            Message("Hey Ramon", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 2)),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 1))
            
            
        ], hasUnreadMessage: true)
    ]
}

// Api
// MARK: - DriverUsers
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let driverUsers = try? newJSONDecoder().decode(DriverUsers.self, from: jsonData)

 

// MARK: - DriverUsers
struct DriverUsers: Codable {
    let status: Bool
    let data: [driver_users]
}

// MARK : - All Drivers
struct AllDriverUsers: Codable {
    let status: Bool
    let data: [All_drivers_users]
}

struct All_drivers_users: Codable {
    let name : String
    let driver_id : String
    let picture_name : String
    let lastMessage: LastMessage?
    
    enum CodingKeys : String, CodingKey {
        case name = "NAME"
        case driver_id = "DRIVER_ID"
        case picture_name = "picture_name"
        case lastMessage = "last_message"
    }
}


// MARK: - Datum
struct driver_users: Codable {
    let name, driverID, lastTrip, currentTrip: String
    let nextTrip: String
    let pictureName: String
    let session: Session?
    let lastMessage: LastMessage?
    let lastPosition: LastPosition?

    enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case driverID = "DRIVER_ID"
        case lastTrip = "LAST_TRIP"
        case currentTrip = "CURRENT_TRIP"
        case nextTrip = "NEXT_TRIP"
        case pictureName = "picture_name"
        case session, lastMessage
        case lastPosition = "last_position"
    }
}

// MARK: - LastMessage
struct LastMessage: Codable {
    let id: Int
    let content: String
    let sessionID: Int
    let createdAt, updatedAt: String
    let uuid: String?
    let type: TypeEnum
    let tripNumber: Int

    enum CodingKeys: String, CodingKey {
        case id, content
        case sessionID = "session_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uuid, type
        case tripNumber = "trip_number"
    }
}

enum TypeEnum: String, Codable {
    case text = "text"
    case image = "image"
    
}

// MARK: - LastPosition
struct LastPosition: Codable {
    let driverID: String
    let latitude, longitude: Double
    let locComment: String
    let tripNumber: Int

    enum CodingKeys: String, CodingKey {
        case driverID = "DRIVER_ID"
        case latitude, longitude
        case locComment = "LOC_COMMENT"
        case tripNumber = "TRIP_NUMBER"
    }
}

// MARK: - Session
struct Session: Codable {
    let id: Int
    let user1ID, user2ID, trip, createdAt, driver_id : String
    let updatedAt: String
//    let sessionOpen: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case user1ID = "user1_id"
        case user2ID = "user2_id"
        case trip
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case driver_id = "DRIVER_ID"
//        case sessionOpen = "open"
    }
}

