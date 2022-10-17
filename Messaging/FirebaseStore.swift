//
//  FirebaseStore.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 17/10/22.
//

import Foundation
import Firebase

class FirebaseDataStore {
    
    let db = Firestore.firestore()
    
    private var docReference: DocumentReference?
    
    func getChannels() {
        print("getting all channels")
        print("UserId => \(UserDefaults.userId ?? "No Id Found")")
        let usersList = db.collection("Chats").whereField("users", arrayContains: UserDefaults.userId ?? "")
        usersList.getDocuments { chatQuerySnap, error in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //                    self.createNewChat()
                    print("No Query Count found.")
                }
                else if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        print(doc.data())
                    }
                }
            }
        }
    }
    
    func getUsersList() {
        db.collection("UsersList").getDocuments { querySnapShot, error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if querySnapShot?.documents == nil {
                    print("no channels or threads found for this user's organization\n. No worries a brand new one will automatically be created when you first attempt to send a message")
                }else {
                    for document in querySnapShot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        guard let userList = data["Users"] as? [String] else { return }
                        print(userList)
                    }
                }
            }
        }
    }
    
    func checkPath(path: [String], dbRepresentation: [String:Any]){
        print("checking for the db snapshopt of main chat store: '\(path[0])'")
        db.collection(path[0]).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents != nil {
                    print("checking for channelID: \(path[1])")
                    let channelIDRef = self.db.collection(path[0]).document(path[1])
                    channelIDRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("chat thread exists for \(dbRepresentation)")
                        } else {
                            print("adding indexable values to the database representation")
                            var modifiedDBRepresentation = dbRepresentation
                            if let participants = (dbRepresentation["id"] as? String)?.components(separatedBy: ":"){
                                modifiedDBRepresentation["participants"] = participants
                            }else{
                                print("somehow we didn't have participant IDs, big issues")
                            }
                            print("chat thread does not currently exist for \(dbRepresentation)")
                            print("creating chat thread for \(dbRepresentation)")
                            channelIDRef.setData(dbRepresentation) { err in
                                if let err = err {
                                    print("Firestore error returned when creating chat thread!: \(err)")
                                } else {
                                    print("chat thread successfully created")
                                }
                            }
                        }
                    }
                }else{
                    print("querySnapshot.documents was nil")
                    self.db.collection(path[0]).document(path[1]).setData(dbRepresentation){ err in
                        if let err = err {
                            print("Firestore error returned when creating chat thread!: \(err)")
                        } else {
                            print("chat channel and thread successfully created!")
                        }
                    }
                }
            }
        }
    }
}
