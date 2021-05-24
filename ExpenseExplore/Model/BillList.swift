//
//  BillList.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 14/5/2564 BE.
//


import Foundation
import Firebase

class BillList: ObservableObject {
    private let collectionName = "bills"
    private let db = Firestore.firestore()
    @Published var bills: [Bill] = []
    
    init() {
        loadAll()
    }
    
    func addBill(name: String, billPrice: String, date: Date, userID: String) {
        db.collection(collectionName).addDocument(data: [
            "name": name,
            "billPrice": billPrice,
            "date": date,
            "userID": userID
        ])
        loadAll()
    }
    
    func updateBill(id: String, name: String, billPrice: String, date: Date, userID: String) {
        db.collection(collectionName).document(id).updateData([
            "name": name,
            "billPrice": billPrice,
            "date": date,
            "userID": userID
        ]) { error in
            print(error ?? "Update failed.")
        }
        loadAll()
    }
    
    func remove(at index: Int, userID: String) {
        let billToDelete = bills[index]
        db.collection(collectionName).document(billToDelete.id).delete()
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
            
            self.bills = documents.compactMap { document in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let billPrice = data["billPrice"] as? String,
                      let timestamp = data["date"] as? Timestamp,
                      let userID = data["userID"] as? String
                else {
                    return nil
                }
                return Bill(id: document.documentID, name: name, billPrice: billPrice, date: timestamp.dateValue() , userID: userID)
            }
        }
    }
}
