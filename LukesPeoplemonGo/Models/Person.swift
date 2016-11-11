//
//  Person.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import UIKit
import Alamofire
import Freddy
import MapKit

class Person: NetworkModel {
    
    var userId: String?
    var userName: String?
    var avatarBase64: String?
    var latitude: Double?
    var longitude: Double?
    var created: String?
    var radius: Double?
    var caughtUserId: String?
    var conversationId: String?
    var recipientId: String?
    var recipientName: String?
    var lastMessage: String?
    var messageCount: Int?
    var senderId: String?
    var senderName: String?
    var recipientAvatarBase64: String?
    var senderAvatarBase64: String?
    var grant_type: String?
    var expiration: Int?
    
    
    
    
    enum RequestType {
        case nearby
        case checkIn
        case catchPerson
        case caught
        case conversations
        case register
        case login
        
    }
    var requestType: RequestType = .nearby
    
    required init() {requestType = .caught}
    
    // create an object from JSON
    required init(json: JSON) throws {
        userId = try? json.getString(at: Constants.Person.userId)
        userName = try? json.getString(at: Constants.Person.userName)
        avatarBase64 = try? json.getString(at: Constants.Person.avatarBase64)
        latitude = try? json.getDouble(at: Constants.Person.latitude)
        longitude = try? json.getDouble(at: Constants.Person.longitude)
        created = try? json.getString(at: Constants.Person.created)
        radius = try? json.getDouble(at: Constants.Person.radius)
        caughtUserId = try? json.getString(at: Constants.Person.caughtUserId)
        conversationId = try? json.getString(at: Constants.Person.conversationId)
        recipientId = try? json.getString(at: Constants.Person.recipientId)
        recipientName = try? json.getString(at: Constants.Person.recipientName)
        lastMessage = try? json.getString(at: Constants.Person.lastMessage)
        
        messageCount = try? json.getInt(at: Constants.Person.messageCount)
        senderId = try? json.getString(at: Constants.Person.senderId)
        senderName = try? json.getString(at: Constants.Person.senderName)
        recipientAvatarBase64 = try? json.getString(at: Constants.Person.recipientAvatarBase64)
        senderAvatarBase64 = try? json.getString(at: Constants.Person.senderAvatarBase64)
        grant_type = try? json.getString(at: Constants.Person.grantType)
        expiration = try? json.getInt(at: Constants.Person.expiration)
        
    }
    
    init(radius: Double) {
        self.radius = radius
        requestType = .nearby
    }
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        requestType = .checkIn
    }
    
    init(caughtUserId: String, radius: Double) {
        self.caughtUserId = caughtUserId
        self.radius = radius
        requestType = .catchPerson
    }
    init(userId: String, userName: String, created: String, avatarBase64: String) {
        self.userId = userId
        self.userName = userName
        self.created = created
        self.avatarBase64 = avatarBase64
        requestType = .caught
    }
    
    init(conversationId: Int, recipientId: String, recipientName: String, lastMessage: String, created: String, messageCount: Int, avatarBase64: String, senderId: String, senderName: String, recipientAvatarBase64: String, senderAvatarBase64: String) {
        self.conversationId = "0"
        self.recipientId = recipientId
        self.recipientName = recipientName
        self.lastMessage = lastMessage
        self.created = created
        self.messageCount = messageCount
        self.avatarBase64 = avatarBase64
        self.senderId = senderId
        self.senderName = senderName
        self.recipientAvatarBase64 = recipientAvatarBase64
        self.senderAvatarBase64 = senderAvatarBase64
        requestType = .conversations
        
    }
    
    // Always return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .nearby:
            return .get
        case .checkIn:
            return .post
        case .catchPerson:
            return .post
        case .caught:
            return .get
        case .conversations:
            return .get
        default:
            return .get
        }
    }
    // A sample path to a single post
    func path() -> String {
        switch requestType {
        case .nearby:
            return "/v1/User/Nearby/"
        case .checkIn:
            return "/v1/User/CheckIn"
        case .catchPerson:
            return "/v1/User/Catch"
        case .caught:
            return "/v1/User/Caught"
        case .conversations:
            return "/v1/User/Conversations"
            //case .conversation:
        //return "/v1/User/Conversation"
        case .login:
            return "/token"
        case .register:
            return "/api/Account/Register"
            
        }
    }
    // Demo object isn't being posted to a server, so just return nil
    func toDictionary() -> [String: AnyObject]? {
        var params: [String: AnyObject] = [:]
        switch requestType {
        case .checkIn:
            //let startDate = Utils.adjustedTime().toString(.iso8601(nil))
            params[Constants.Person.latitude] = latitude as AnyObject?
            params[Constants.Person.longitude] = longitude as AnyObject?
        case .catchPerson:
            params[Constants.Person.caughtUserId] = caughtUserId as AnyObject?
            params[Constants.Person.radius] = radius as AnyObject?
        // params[Constants.Person.longitude] = longitude as AnyObject?
        case .nearby:
            params[Constants.Person.radius] = radius as AnyObject?
        case .caught:
            break
        default:
            break
        }
        return params
    }
    
    
}
