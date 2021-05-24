//
//  EventView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 13/5/2564 BE.
//

import SwiftUI

struct EventView : View {
    @EnvironmentObject private var expenseList: ExpenseList
    @EnvironmentObject private var eventList: EventList
    @EnvironmentObject private var userModel: UserModel
    @State private var showAddEventView: Bool = false
    @State private var showUsage = false
    
    
    var body: some View {
        List {
            
            ForEach(filteredID(userID: userModel.userID)) { event in
                HStack {
                
                    Text(event.name)
                        .frame(width:70)
                        .padding()
                    Spacer()
                    if !showUsage {
                        Text("limit: ")
                        Text("\(event.limit) \(userModel.currency)")
                    } else {
                        Text("usage: ")
                        Text("\(usageCalculator(event: event.name, userID: event.userID))"+" /"+" \(event.limit) \(userModel.currency)")
                    }
                    
                }
                .padding()
                
            }
            .onDelete{ indexSet in
                if let index = indexSet.first {
                    eventList.remove(at: index, userID: userModel.userID)
                }
            }
            .onTapGesture {
                showUsage.toggle()
            }
            
           
            }
        .padding()
        .navigationBarTitle("Events",displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                showAddEventView.toggle()
            }, label: {
                Text("Add")
            }))
        .sheet(isPresented: $showAddEventView) {
            AddEventView( showAddEventView: $showAddEventView )
        }
    }
    func usageCalculator(event: String, userID: String) -> String{
        let filteredID = expenseList.expenses.filter {$0.userID == userID}
        let filteredEvent = filteredID.filter {$0.event == event}
        var sum = 0
        print(filteredEvent)
        for t in filteredEvent {
            sum = sum + Int(t.amount)!
            
        }
        return "\(sum)"
    }
    
    func filteredID(userID: String) -> [Event] {
        let filtered = eventList.events.filter { $0.userID == userID}
        return filtered
    }
}

struct AddEventView: View {
    @EnvironmentObject private var userModel: UserModel
    @EnvironmentObject private var eventList: EventList
    @State private var name = ""
    @ObservedObject var limitInput = NumbersOnly()
    @Binding var showAddEventView: Bool
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Spacer()
                    Text("Create Your Event")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    Spacer()
                }
                
                TextField("Title", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .padding()
                TextField("Limit", text: $limitInput.value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .keyboardType(.decimalPad)
                    .padding()
                
                
            }
            .padding()
            .padding()
            .navigationBarItems(
                leading: Button(action: {
                    showAddEventView.toggle()
                }) {
                    Text("Cancle")
                },
                trailing: Button(action: {
                    showAddEventView = false
                    eventList.addEvent(name: name, limit: limitInput.value, userID: userModel.id)
                }) {
                    Text("Done")
                })
            
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
            .environmentObject(EventList())
            .environmentObject(UserModel())
    }
}
