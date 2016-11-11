//
//  UserStore.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/8/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import Foundation
import UIKit

class UserStore {
    // singleton
    static let shared = UserStore()
    
    var selectedImage: UIImage?
    var user:User?
    private init() {}
    
    
    func login(_ loginUser: User, completion:@escaping
        (_ success:Bool, _ error: String?) -> ()) {
        
        // Call web service to login
        WebServices.shared.authUser(loginUser) { (user, error) in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expiration)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func register(_ registerUser: User, completion:@escaping
        (_ success:Bool, _ error: String?) -> ()) {
        
        // Call web service to login
        WebServices.shared.authUser(registerUser) { (user, error) in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expiration)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func logout(_ completion:() -> ()) {
        WebServices.shared.clearUserAuthToken()
        completion()
    }
    
}
