//
//  FirebaseChatChannel.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 17/10/22.
//

import Foundation
import FirebaseFirestore

protocol DatabaseRepresentation {
  var representation: [String: Any] { get }
}

struct FirebaseChatChannel {

    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard let name = data["name"] as? String else {
            return nil
        }

        id = document.documentID
        self.name = name
    }
}

extension FirebaseChatChannel: DatabaseRepresentation {

    var representation: [String : Any] {
        var rep = ["name": name]
        rep["id"] = id
        return rep
    }

}

extension FirebaseChatChannel: Comparable {

    static func == (lhs: FirebaseChatChannel, rhs: FirebaseChatChannel) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: FirebaseChatChannel, rhs: FirebaseChatChannel) -> Bool {
        return lhs.name < rhs.name
    }

}

