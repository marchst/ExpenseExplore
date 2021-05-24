//
//  ExpenseView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//


import SwiftUI

struct ExpenseView: View {
    @EnvironmentObject private var userModel: UserModel
    @State private var showEditTransactionView = false
    var expense: Expense
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 3, x: 0, y: 0)
                    .padding(.trailing, 25)
                    .padding(.leading, 25)
                    .padding(.bottom, 170)
                ScrollView {
                    HStack {
                        Spacer()
                        Text(expense.name)
                            .font(.largeTitle).bold()
                        Spacer()
                    }
                    .padding()
                    
                    LazyVStack (alignment: .leading) {
                        HStack{
                            Image(systemName: "bookmark")
                            Text(expense.type)
                                .font(.title2)
                                .padding()
                        }
                        .padding()
                        
                        HStack{
                            Image(systemName: "dollarsign.square")
                            Text("\(expense.amount) \(userModel.currency)")
                                .font(.title2)
                                .padding()
                        }
                        .padding()
                        
                        HStack{
                            Image(systemName: "calendar")
                            Text(expense.date, style: .date)
                                .font(.title2)
                                .padding()
                        }
                        .padding()
                        
                        HStack{
                            Image(systemName: "clock")
                            Text(expense.date, style: .time)
                                .font(.title2)
                                .padding()
                        }
                        .padding()
                    }
                    .padding(.leading, 40)
                    
                }
                
            }
            
            
        }
        .navigationBarItems(
            trailing: Button(action: {
                showEditTransactionView.toggle()
            }) {
                Text("Edit")
            }
            .sheet(isPresented: $showEditTransactionView) {
                let selectedType = findIndexOfType(type: expense.type)
                UpdateExpenseView(id: expense.id,name: expense.name, amount: expense.amount, eventName: expense.event, selectedType: selectedType, selectedShow: Bool(expense.showInReport)!, date: expense.date, showEditTransactionView: $showEditTransactionView)
            })
        
    }
    
    private func findIndexOfType(type: String) -> Int {
        if(type == "Income"){
            return 0
        } else {
            return 1
        }
    }
}


struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView(expense: Expense(id: "", name: "TestView", amount: "1000", date: Date(), showInReport: "true", type: "Expense", userID: "", event: ""))
            .environmentObject(UserModel())
    }
}
