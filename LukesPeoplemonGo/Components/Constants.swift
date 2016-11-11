//
//  Constants.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let monthDayYear = "MM/dd/yyyy"
    
    
    // Keychain strings
    public static let keychainIdentifier = "LukesPeoplemonGoKeychain"
    public static let authTokenExpireDate = "authTokenExpireDate"
    public static let authToken = "authToken"
    static let apiKey = "iOSandroid301november2016"
    static let radius = 100.0
    
    
    
    // JSON Constants
    struct JSON {
        static let unknownError = "An Unknown Error Has Occurred"
        static let processingError = "There was an error processing the response"
    }
    
    // User Constants
    struct User {
        static let id = "Id"
        static let email = "Email"
        static let hasRegistered = "HasRegistered"
        static let loginProvider = "LoginProvider"
        static let fullName = "FullName"
        static let avatarBase64 = "AvatarBase64"
        static let lastCheckInLongitude = "LastCheckInLongitude"
        static let lastCheckInLatitude = "LastCheckInLatitude"
        static let lastCheckInDateTime = "LastCheckInDateTime"
        static let oldPassword = "OldPassword"
        static let newPassword = "NewPassword"
        static let confirmPassword = "ConfirmPassword"
        static let apiKey = "ApiKey"
        static let password = "password"
        static let grantType = "grant_type"
        static let userName = "username"
        static let token = "access_token"
        static let expirationDate = ".expires"
        
    }
    
    // Person Constants
    struct Person {
        static let userId = "UserId"
        static let userName = "UserName"
        static let avatarBase64 = "AvatarBase64"
        static let longitude = "Longitude"
        static let latitude = "Latitude"
        static let created = "Created"
        static let radius = "RadiusInMeters"
        static let caughtUserId = "CaughtUserId"
        static let conversationId = "ConversationId"
        static let recipientId = "RecipientId"
        static let recipientName = "RecipientName"
        static let lastMessage = "LastMessage"
        static let messageCount = "MessageCount"
        static let senderId = "SenderId"
        static let senderName = "SenderName"
        static let recipientAvatarBase64 = "RecipientAvatarBase64"
        static let senderAvatarBase64 = "SenderAvatarBase64"
        static let grantType = "grant_type"
        static let expiration = "Expiration"
        
    }
    
    
}

// MARK: - Colors
// UIColor extension and
extension UIColor {
    public class func rgba(red: NSInteger, green: NSInteger, blue: NSInteger, alpha: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
}

struct ColorPalette {
    static let PositiveColor = UIColor.rgba(red: 15, green: 181, blue: 46)
    static let NegativeColor = UIColor.rgba(red: 219, green: 31, blue: 31)
    static let BlueColor = UIColor.rgba(red: 12, green: 35, blue: 64)
    static let GoldColor = UIColor.rgba(red: 201, green: 151, blue: 0)
    static let calendarCellColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
    static let calendarTodayColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.3)
    static let calendarBorderColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.8)
}
