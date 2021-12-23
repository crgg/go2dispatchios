//
//  ChatModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 9/29/21.
//

import Foundation

struct New_messag_received : Decodable{
    var session_id : Int = 0
    var where_coming : String = ""
    var to_user : String = ""
    var user_send : String = ""
    var message : String = ""
    var content: String = ""
    var date: String = ""
    var uuid : UUID?
    var trip : Int = 0
    var type_content : TypeEnum = .text
    
    init() {
        
    }
    init(_ dict : [String : Any]) {
        if let uuided =  dict["UUID"] as? String {
            self.uuid = UUID(uuidString: uuided)
        }
        if let dated = dict["date"] as? String {
            self.date  = dated
        }
        if let contented = dict["content"] as? String {
            self.content = contented
            if contented == "image" {
                self.type_content = .image
            }
        }
        
        
        if let message = dict["message"] as? String {
            self.message = message
        }
        if let sessionId =  dict["session_id"] as? Int {
            self.session_id =  sessionId
        }
        if let trip = dict["trip"] as? Int {
            self.trip =  trip
        }
        if let user_send = dict["user_send"] as? String{
            self.user_send = user_send
        }
        if let whered =  dict["where"] as? String {
            self.where_coming = whered
        }
        if let to_user = dict["to_user"] as? String {
            self.to_user = to_user
        }
        
        
    }
    
}


struct Chat: Identifiable {
    var id : UUID { person.id }
    var person : Person
    var messages: [Message]
    var hasUnreadMessage = false
    var online : Bool = false
    var session_id : Int = 0
    
    
}
enum contentType : String {
    case text
    case image
    case video
}
struct Person: Identifiable {
    let id = UUID()
    var name : String
    var driver_id : String
    var imgString : String
}
enum MessageType {
    case send
    case received
}

struct Message : Identifiable {

    let id = UUID()
    var date : Date
    var text : String
    var type : MessageType
    var content_type : contentType
    var readed : Bool  = true
    init(_ text: String, type : MessageType, date: Date, content_type: contentType) {
        self.date = date
        self.type = type
        self.text = text
        self.content_type = content_type
       
    }
    init(_ text: String, type: MessageType , content_type : contentType, readed : Bool) {
        self.date = Date()
        self.type = type
        self.text = text
        self.content_type = content_type
        self.readed = readed
       
    }
    init(_ text: String, type: MessageType , content_type : contentType, readed : Bool, date: Date) {
       
        self.type = type
        self.text = text
        self.content_type = content_type
        self.readed = readed
        self.date = date
       
    }
 
    
    
    init(_ text: String, type: MessageType , content_type : contentType) {
        self.init(text, type:type, date: Date(), content_type: content_type)
    }
    
}

extension Chat {
    static let sampleChat = [
        Chat(person: Person(name: "Paulette Gajardo", driver_id:"Paulette", imgString: "Avatar Users2_1"), messages : [
            Message("Hey Paullete", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Yes Dale", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Aguante el Bullita", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Vamo con todo", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text)
        ], hasUnreadMessage: true, online: true),
        
        Chat(person: Person(name: "Raymond Gajardo", driver_id: "Raymond", imgString: "Avatar Users2_2"), messages : [
            Message("Hey Raymond", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 1), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 1), content_type: .text)
            
            
        ], hasUnreadMessage: true,  online: true),
        Chat(person: Person(name: "Paola Carvallo", driver_id: "Paola",  imgString: "Avatar Users2_3"), messages : [
            Message("Hey Paola", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 2), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 1), content_type: .text)
            
            
        ], hasUnreadMessage: false),
        Chat(person: Person(name: "Ramon Gajardo", driver_id: "Ramon", imgString: "Avatar Users2_4"), messages : [
            Message("Hey Ramon", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Please I need your help", type: .send, date: Date(timeIntervalSinceNow: -86400 * 2), content_type: .text),
            Message("I m jsust developing an Whatsapp clone app hello", type: .send, date: Date(timeIntervalSinceNow: -86400 * 3), content_type: .text),
            Message("Sure I can do that no problem", type: .received, date: Date(timeIntervalSinceNow: -86400 * 1), content_type: .text)
            
            
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
    let user_of_chat : String?

    enum CodingKeys: String, CodingKey {
        case id, content
        case sessionID = "session_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uuid, type
        case user_of_chat = "user"
        case tripNumber = "trip_number"
    }
    
    func returnDic() -> [String : Any] {
        return [CodingKeys.id.rawValue : id,
                CodingKeys.content.rawValue : content,
                CodingKeys.sessionID.rawValue : sessionID,
                CodingKeys.createdAt.rawValue : createdAt,
                CodingKeys.updatedAt.rawValue  : updatedAt,
                CodingKeys.uuid.rawValue  : uuid as Any,
                CodingKeys.type.rawValue  : type,
                CodingKeys.user_of_chat.rawValue : user_of_chat ?? "",
                CodingKeys.tripNumber.rawValue  : tripNumber ]
    }
}

enum TypeEnum: String, Codable {
    case text = "text"
    case image = "image"
    case video = "video"
    
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


 


// MARK: - MessageChat
struct MessagesReceived: Codable {
    let status: Bool
    let data: [MessagesList]
}

// MARK: - Datum
struct MessagesList: Codable {
    var message: String
    var id, sessionID, type: Int
    var readAt: DAt?
    var sendAt: DAt
    var content: TypeEnum
    var trip : Int?
    var uuid: String?
    var user: String
    var messageParse : Message
 
    
    enum CodingKeys: String, CodingKey {
        case message, id
        case sessionID = "session_id"
        case type
        case readAt = "read_at"
        case sendAt = "send_at"
        case content, uuid, user, trip
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        message =  try  values.decode(String.self, forKey: .message)
        id  = try values.decode(Int.self, forKey: .id)
        sessionID = try values.decode(Int.self, forKey: .sessionID)
        type = try values.decode(Int.self, forKey: .type)
        readAt = try? values.decode(DAt.self, forKey: .readAt)
        sendAt = try values.decode(DAt.self, forKey: .sendAt)
        content = try values.decode(TypeEnum.self, forKey: .content)
        trip = try? values.decode(Int.self, forKey: .trip)
        uuid = try? values.decode(String.self, forKey: .uuid)
        user = try values.decode(String.self, forKey: .user)
 
        var type_content : contentType = .text
        switch(content) {
        case .text:
            type_content = .text
            
        case .image:
            type_content = .image
        case .video:
            type_content = .video
        }
        
        let dateString  =  sendAt.date
        var dateResult = Date()
        let formatter = DateFormatter()
        formatter.dateFormat =   "yyyy-MM-dd HH:mm:ss.000000"
        formatter.locale = Locale(identifier: "en_us")
        if let yourDate = formatter.date(from: dateString) {
            dateResult =  yourDate
        }
         
        self.messageParse = Message(self.message, type: type == 1 ? .received : .send, content_type: type_content
                                    , readed : (readAt != nil), date: dateResult)
        
    }
    
    init(message: String, id : Int, sessionID : Int,  type: Int, readAt: DAt? ,sendAt: DAt,
content: TypeEnum, trip : Int?, uuid: String?, user: String,  messageParse : Message) {
        self.message = message
        self.id = id
        self.sessionID = sessionID
        self.type = type
        self.readAt = readAt
        self.sendAt = sendAt
        self.content = content
        self.trip = trip
        self.uuid = uuid
        self.user = user
        self.messageParse = messageParse
}
    
 
}

 
// MARK: - DAt
struct DAt: Codable {
    let date: String
    let timezoneType: Int
    let timezone: Timezone

    enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
}

enum Timezone: String, Codable {
    case americaChicago = "America/Chicago"
}
//
//extension MessageChat {
//    init(dict : [String: Any]) {
//        if let c = dict["id"] as? Int {
//            self.id = c
//        }
//        if let t = dict["type"] as? Int {
//            self.type = t
//        }
//        if let d = dict["date"]  as? String {
//            self.date = d
//        }
//        if let me = dict["message"] as? String {
//            self.message = me
//        }
//        if let tr = dict["trip"] as? String {
//            self.trip = tr
//        }
//        if let us = dict["user"] as? String {
//            self.user = us
//        }
//
//        if let session_id  = dict["session_id"] as? Int {
//            self.session_id = session_id
//        } else {
//            if let session_id = dict["session_id"] as? String {
//                self.session_id = Int(session_id)
//            }
//        }
//
//
//        if let url = dict["url"] as? String {
//            self.url = url
//        }
//        if let uid =  dict["uuid"] as? String {
//
//            if let uui = UUID(uuidString: uid) {
//                self.uuid = uui
//            }
//
//        } else if let uid = dict["UUID"] as? String {
//            self.uuid = UUID(uuidString: uid)!
//        }
//
//
//        if let sendd = dict["send_at"] as? [String : Any] {
//            self.send_at  =  Send_at(da : sendd)
//        }
//        if let content = dict["content"] as? String {
//            self.content = content
//        }
//        if let readat = dict["read_at"] as? [String: Any] {
//            self.read_at =  readat
//            self.status = "send"
//        } else {
//            print(" 🔥 no read at come")
//            self.status = "no_read"
//
//        }
//    }
//}

 

// MARK: MessageRequest
// MARK: - MessageRequest
struct MessageRequest: Codable {
    let status: Bool
    let data: DataMessageRequest
}

// MARK: - DataClass
struct DataMessageRequest: Codable {
    let sessionID, type: Int
    let userID: String
    let messageID: Int
    let updatedAt, createdAt: String
    let id: Int
    let typeContent: String
    let message: MsgRequest

    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case type
        case userID = "user_id"
        case messageID = "message_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case typeContent = "type_content"
        case message
    }
}

// MARK: - Message
struct MsgRequest: Codable {
    let id: Int
    let content: String
    let sessionID: Int
    let createdAt, updatedAt: String
    let uuid: JSONNull?
    let type: String
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

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

