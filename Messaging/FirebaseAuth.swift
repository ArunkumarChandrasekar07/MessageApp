//
//  FirebaseAuth.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticator {
    
    private static var privateSharedInstance: FirebaseAuthenticator!
    
    static var sharedInstance: FirebaseAuthenticator {
        if privateSharedInstance == nil {
            privateSharedInstance = FirebaseAuthenticator()
        }
        return privateSharedInstance
    }
    
    func createNewUser(with email: String, password: String, onCompletion: @escaping ((_ user: User?, _ message: String?)->())) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            onCompletion(authResult?.user, error?.localizedDescription)
        }
    }
    
    func signInUser(with email: String, password: String, onCompletion: @escaping ((_ user: User?, _ message: String?)->())) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            onCompletion(authResult?.user, error?.localizedDescription)
        }
    }
    
    func addUserOnDB(_ user: User) {
        
    }
}
