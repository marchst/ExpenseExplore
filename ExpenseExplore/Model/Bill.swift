//
//  Bill.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 14/5/2564 BE.
//

import Foundation

struct Bill : Identifiable{
    let id: String
    let name: String
    let billPrice: String
    let date: Date
    let userID: String
}
