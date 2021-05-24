//
//  SearchView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @EnvironmentObject private var expenseList: ExpenseList
    @EnvironmentObject private var userModel: UserModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
                    .navigationBarTitle("Search")
                List {
                    ForEach(findAndSorted(searchText: searchText, expenseList: expenseList)) { expense in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .foregroundColor(colorOfAmount(type: expense.type))
                                    .frame(width: 110)
                                Text(addAmountSymbol(amount: expense.amount, type: expense.type)).bold()
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .padding(.trailing)
                            VStack {
                                Text(expense.name)
                                Text(expense.date.addingTimeInterval(600), style: .date)
                            }
                            
                            
                        }
                        .padding()
                    }
                    
                }
                .animation(.default)
            }
            
        }
    }
    
    func findAndSorted(searchText: String, expenseList: ExpenseList) -> ([Expense]) {
        let filteredUserID = expenseList.expenses.filter {$0.userID == userModel.userID}
        let formatterDayDigit = DateFormatter()
        formatterDayDigit.dateFormat = "d"
        let formatterMonthDigit = DateFormatter()
        formatterMonthDigit.dateFormat = "M"
        var filteredExpense = filteredUserID.filter({ searchText.isEmpty ? false : $0.name.contains(searchText)})
        filteredExpense.sort(by: { Int(formatterDayDigit.string(from: $0.date))! > Int(formatterDayDigit.string(from: $1.date))!})
        filteredExpense.sort(by: { Int(formatterMonthDigit.string(from: $0.date))! > Int(formatterMonthDigit.string(from: $1.date))!})
        return filteredExpense
    }
    
    func colorOfAmount(type: String) -> Color {
        let color: Color
        if type == "Income" {
            color = Color.green
        } else {
            color = Color.red
        }
        return color
    }
    
    func addAmountSymbol(amount: String, type: String) -> String {
        let amounts: String
        if type == "Income" {
            amounts = "+ \(amount) \(userModel.currency)"
        } else {
            amounts = "- \(amount) \(userModel.currency)"
        }
        return amounts
    }
}
    




struct Search_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(ExpenseList())
            .environmentObject(UserModel())
    }
}
