//
//  UpdateExpenseView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import SwiftUI

struct UpdateExpenseView: View {
    @EnvironmentObject private var expenseList: ExpenseList
    @EnvironmentObject private var userModel: UserModel
    @State var id: String
    @State var name: String
    @State var amount: String
    @State var eventName: String
    @State var selectedType: Int
    @State var selectedShow: Bool
    @State var date: Date
    @Binding var showEditTransactionView: Bool
    
    private let transactionTypes = ["Income","Expense"]
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    HStack {
                        Spacer()
                        Text("Edit Transaction")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                        Spacer()
                    }
                    
                    Picker("", selection: $selectedType) {
                        ForEach(0..<transactionTypes.count) {
                            Text(transactionTypes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    TextField("Title", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding()
                    TextField("Amount", text: $amount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .keyboardType(.decimalPad)
                        .padding()
                    
                    Toggle(isOn: $selectedShow) {
                        Text("Show in report")
                    }
                    .padding()
                }
                .padding()
                
                .navigationBarItems(
                    leading: Button(action: {
                        showEditTransactionView.toggle()
                    }) {
                        Text("Cancle")
                    },
                    trailing: Button(action: {
                        showEditTransactionView = false
                        expenseList.updateExpense(id: id, name: name, type: transactionTypes[selectedType], amount: amount, date: date, showInReport: "\(selectedShow)", userID: userModel.userID, event: eventName)
                    }) {
                        Text("Done")
                    })
            }
            .padding()
        }
    }
}

struct UpdateExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateExpenseView(id: "", name: "", amount: "", eventName: "", selectedType: 0, selectedShow: true, date: Date(), showEditTransactionView: .constant(true))
            .environmentObject(ExpenseList())
            .environmentObject(UserModel())
    }
}
