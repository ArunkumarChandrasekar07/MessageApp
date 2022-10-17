//
//  Extension+UserDefauts.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import Foundation

extension UserDefaults {
    
    static var isUserLoggedIn: Bool {
        get {
            return standard.bool(forKey: "login_status")
        }
        set {
            standard.set(newValue, forKey: "login_status")
        }
    }
    
    static var userId: String? {
        get {
            return standard.string(forKey: "login_user_id")
        }
        set {
            standard.set(newValue, forKey: "login_user_id")
        }
    }
    
    static var userName: String? {
        get {
            return standard.string(forKey: "login_user_name")
        }
        set {
            standard.set(newValue, forKey: "login_user_name")
        }
    }
}
