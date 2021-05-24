//
//  Expense.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import Foundation

struct Expense: Identifiable {
    let id: String
    let name: String
    let amount: String
    let date: Date
    let showInReport: String
    let type: String
    let userID: String
    let event: String
}
