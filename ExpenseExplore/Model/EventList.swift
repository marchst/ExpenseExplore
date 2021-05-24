//
//  EventList.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 13/5/2564 BE.
//

import Foundation
import Firebase

class EventList: ObservableObject {
    private let collectionName = "events"
    private let db = Firestore.firestore()
    @Published var events: [Event] = []
    
    init() {
        loadAll()
    }
    
    func addEvent(name: String, limit: String, userID: String) {
        db.collection(collectionName).addDocument(data: [
            "name": name,
            "limit": limit,
            "userID": userID
        ])
        loadAll()
    }
    
    func updateEvent(id: String, name: String, limit: String, userID: String) {
        db.collection(collectionName).document(id).updateData([
            "name": name,
            "limit": limit,
            "userID": userID
        ]) { error in
            print(error ?? "Update failed.")
        }
        loadAll()
    }
    
    func remove(at index: Int, userID: String) {
        let filteredUserID = events.filter {$0.userID == userID}
        let eventToDelete = filteredUserID[index]
        db.collection(collectionName).document(eventToDelete.id).delete()
        loadAll()
    }
    
    private func loadAll() {
        db.collection(collectionName).getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
        
            guard let documents = snapshot?.documents else {
                return
            }
            
            self.events = documents.compactMap { document in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let limit = data["limit"] as? String,
                      let userID = data["userID"] as? String
                else {
                    return nil
                }
                return Event(id: document.documentID, name: name, limit: limit, userID: userID)
            }
        }
    }
}
