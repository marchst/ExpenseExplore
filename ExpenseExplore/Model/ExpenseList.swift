//
//  ExpenseList.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//


import Foundation
import Firebase

class ExpenseList: ObservableObject {
    private let collectionName = "expenses"
    private let db = Firestore.firestore()
    @Published var date = Date()
    @Published var expenses: [Expense] = []
    
    init() {
        loadAll()
    }
    
    func addExpense(name: String, type: String, amount: String, date: Date, showInReport: String, userID: String, event: String) {
        db.collection(collectionName).addDocument(data: [
            "name": name,
            "type": type,
            "amount": amount,
            "date": date,
            "showInReport": showInReport,
            "userID": userID,
            "event": event
        ])
        loadAll()
    }
    
    func updateExpense(id: String, name: String, type: String, amount: String, date: Date, showInReport: String, userID: String, event: String) {
        db.collection(collectionName).document(id).updateData([
            "name": name,
            "type": type,
            "amount": amount,
            "date": date,
            "showInReport": showInReport,
            "userID": userID,
            "event": event
        ]) { error in
            print(error ?? "Update failed.")
        }
        loadAll()
    }
    
    func remove(at index: Int, date: Date, userID: String) {
        let filteredUserID = expenses.filter {$0.userID == userID}
        let formatterDayDigit = DateFormatter()
        formatterDayDigit.dateFormat = "d"
        let filteredDay = filteredUserID.filter { formatterDayDigit.string(from: $0.date) == formatterDayDigit.string(from: date)}
        let expenseToDelete = filteredDay[index]
        db.collection(collectionName).document(expenseToDelete.id).delete()
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
            
            self.expenses = documents.compactMap { document in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let type = data["type"] as? String,
                      let amount = data["amount"] as? String,
                      let timestamp = data["date"] as? Timestamp,
                      let showInReport = data["showInReport"] as? String,
                      let userID = data["userID"] as? String,
                      let event = data["event"] as? String
                else {
                    return nil
                }
                return Expense(id: document.documentID, name: name, amount: amount, date: timestamp.dateValue(), showInReport: showInReport, type: type, userID: userID, event: event)
            }
        }
    }
}
