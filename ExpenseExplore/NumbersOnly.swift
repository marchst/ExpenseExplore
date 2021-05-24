//
//  NumbersOnly.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 6/5/2564 BE.
//

import Foundation

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filterd = value.filter { $0.isNumber }
            
            if value != filterd {
                value = filterd
            }
        }
    }
}
