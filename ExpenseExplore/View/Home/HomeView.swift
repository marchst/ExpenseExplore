//
//  HomeView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var expenseList: ExpenseList
    @EnvironmentObject private var eventList: EventList
    @EnvironmentObject private var userModel: UserModel
    @State private var showAddTransactionView = false
    @State private var showDatePicker = false
    @State private var selectDate = Date()
    @State private var listViewId = UUID()
    @State private var selectedItem: String?
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text("Home")
                        .font(.largeTitle)
                        .bold()
                        .frame(height: 25, alignment: .topLeading)
                        .padding(.leading, 20)
                    Spacer()
                    
                    Button(action: {
                        showAddTransactionView.toggle()
                    }) {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .padding(.top,0)
                            .padding(.trailing)
                    }
                    .sheet(isPresented: $showAddTransactionView) {
                        AddTransactionView(date: $expenseList.date, showAddTransactionView: $showAddTransactionView, userID: $userModel.userID, events: .constant(eventList.events))
                    }
                    .padding(.trailing)
                    
                }
                if showDatePicker {
                    VStack {
                        DatePicker("Date", selection: $selectDate, displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                        Button(action: {
                            showDatePicker.toggle()
                            expenseList.date = selectDate
                        }, label: {
                            Text("OK")
                                .bold()
                                .foregroundColor(Color(UIColor.systemBlue))
                        })
                    }
                }
                
                
                
                List {
                    ForEach(filterDayOfExpenses(expenseList: expenseList)) { expense in
                        NavigationLink(destination: ExpenseView(expense: expense),tag: expense.id, selection: $selectedItem) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .foregroundColor(colorOfAmount(type: expense.type))
                                        .frame(width: 120)
                                    Text(addAmountSymbol(amount: expense.amount, type: expense.type)).bold()
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                .padding(.trailing)
                                Text(expense.name)
                            }
                            .padding()
                        }
                    }
                    .onDelete{ indexSet in
                        if let index = indexSet.first {
                            expenseList.remove(at: index, date: expenseList.date, userID: userModel.userID)
                        }
                    }
                }
                .id(listViewId)
                .onAppear {
                    if selectedItem != nil {
                        selectedItem = nil
                        listViewId = UUID()
                    }
                }
                .navigationBarTitle("",displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        showDatePicker.toggle()
                    }, label: {
                        Text(expenseList.date, style: .date)
                            .foregroundColor(.gray)
                            .bold()
                    }))
                .animation(.default)
                
            }
            
        }
        
        
    }
    
    func filterDayOfExpenses (expenseList: ExpenseList) -> [Expense] {
        let filteredUserID = expenseList.expenses.filter{ $0.userID == userModel.userID}
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let filteredItems = filteredUserID.filter { formatter.string(from: $0.date) == formatter.string(from: expenseList.date)}
        return filteredItems
    }
    
    func colorOfAmount (type: String) -> Color {
        let color: Color
        if type == "Income" {
            color = Color.green
        } else {
            color = Color.red
        }
        return color
    }
    
    func addAmountSymbol (amount: String, type: String) -> String {
        let amounts: String
        if type == "Income" {
            amounts = "+ \(amount) \(userModel.currency)"
        } else {
            amounts = "- \(amount) \(userModel.currency)"
        }
        return amounts
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ExpenseList())
            .environmentObject(UserModel())
            .environmentObject(EventList())
    }
}
