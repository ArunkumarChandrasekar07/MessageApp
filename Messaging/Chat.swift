//
//  Chat.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Chat: Codable {
    
    var id: String?
    var created: Date
    var user_name: String
    var is_sent_by_me: Bool
    var text: String
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var description: String {
        return self.text
    }
    
    init(user_name: String, text: String, createdAt: Date, is_sent_by_me: Bool) {
        self.created = createdAt
        self.user_name = user_name
        self.text = text
        self.is_sent_by_me = is_sent_by_me
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let created = data["created"] as? Timestamp else {
            return nil
        }
        guard let userName = data["user_name"] as? String else {
            return nil
        }
        guard let text = data["text"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.created = created.dateValue()
        self.user_name = userName
        self.text = text
        self.is_sent_by_me = true
    }
}

struct ChatUsers: Codable {
    var name: String
    var id: String
    var email: String
    var description: String
    var profileImage: String
}

extension Chat: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": created,
            "user_name": user_name,
            "text": text,
            "is_sent_by_me": is_sent_by_me,
        ]
        return rep
    }
}

extension Chat: Comparable {
  
  static func == (lhs: Chat, rhs: Chat) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Chat, rhs: Chat) -> Bool {
    return lhs.created < rhs.created
  }
}
