//
//  AddTransactionView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//


import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject private var expenseList: ExpenseList
    @ObservedObject var amountInput = NumbersOnly()
    @State private var name = ""
    @State private var amount = "0"
    @State private var selectedType = 0
    @State private var selectedShow = true
    @State private var showPicker = false
    @State private var selectedEvent = "-"
    @State private var eventName = "-"
    @Binding var date: Date
    @Binding var showAddTransactionView: Bool
    @Binding var userID: String
    @Binding var events: [Event]

    private let transactionTypes = ["Income","Expense"]
    private let showInReport = ["true","false"]
    private let showInEvents = ["true",]
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    HStack {
                        Spacer()
                        Text("Create Your \nTransaction")
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
                    TextField("Amount", text: $amountInput.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .keyboardType(.decimalPad)
                        .padding()
                    
                    Toggle(isOn: $selectedShow) {
                        Text("Show in report")
                    }
                    .padding()
                    
                    Button(action: {
                        showPicker.toggle()
                    }, label: {
                        HStack {
                            Text("Event")
                            Spacer()
                            Text(eventName)
                        }
                        .foregroundColor(.black)
                        .padding()
                    })
                    if showPicker {
                        VStack {
                            Picker("Event", selection: $selectedEvent) {
                                ForEach(filteredID(userID: userID)) { event in
                                    Text(event.name)
                                    
                                }
                            }
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding()
                            Button(action: {
                                setEventName(id: selectedEvent)
                                showPicker.toggle()
                            }, label: {
                                Text("OK").bold()
                            })
                        }
                        
                    }
                }
                .padding()
                
                
                .navigationBarItems(
                    leading: Button(action: {
                        showAddTransactionView.toggle()
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                    showAddTransactionView = false
                        expenseList.addExpense(name: name, type: transactionTypes[selectedType], amount: amountInput.value, date: date, showInReport: "\(selectedShow)", userID: userID, event: eventName)
                }) {
                    Text("Done")
                })
                
            }
        }
    }
    func setEventName(id: String) {
        let filteredID = events.filter { $0.id == id }
        if !filteredID.isEmpty {
            eventName = filteredID[0].name
        }
        
    }
    
    func filteredID(userID: String) -> [Event] {
        if let _ = events.first(where: {$0.userID == userID})  {
            var filteredID = events.filter { $0.userID == userID}
            filteredID.insert(Event(id: "", name: "-", limit: "0", userID: ""), at: 0)
            return filteredID
        } else {
            return []
        }
        
        
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(date: .constant(Date()), showAddTransactionView: .constant(true), userID: .constant(""), events: .constant([]))
            .environmentObject(ExpenseList())
    }
}
