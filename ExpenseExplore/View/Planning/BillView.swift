//
//  BillView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 14/5/2564 BE.
//

import SwiftUI

struct BillView: View {
    @EnvironmentObject private var billList: BillList
    @EnvironmentObject private var userModel: UserModel
    @State private var showAddBillView = false
    @State private var showBillPrice = false
    var body: some View {
        ZStack {
        List {
            ForEach(filteredID(userID: userModel.userID)) { bill in
                HStack {
                    Text(bill.name)
                        .padding()
                    Spacer()
                    if !showBillPrice {
                        Text(bill.date.addingTimeInterval(600), style: .date)
                    } else {
                        Text("\(bill.billPrice) \(userModel.currency)")
                    }
                    
                }
                .padding()
                .contextMenu {
                    Button("Remind me") {
                        self.addNotification(for: bill,date: bill.date)
                    }
                }
                .onTapGesture {
                    showBillPrice.toggle()
                }
            }
            
            .onDelete{ indexSet in
                if let index = indexSet.first {
                    billList.remove(at: index, userID: userModel.userID)
                }
            }
            
            
        }
        .padding()
        .navigationBarTitle("Bills",displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                showAddBillView.toggle()
            }, label: {
                Text("Add")
            }))
        .sheet(isPresented: $showAddBillView) {
            AddBillView(showAddBillView: $showAddBillView)
        }
        VStack {
            Text("")
                .padding(.bottom, 650)
            Text("Press the bill to set reminder")
                        .foregroundColor(.gray)
                        .font(.caption)
  
        }
        
        }
    }
    
    func addNotification(for bill: Bill, date: Date){
        
        let center = UNUserNotificationCenter.current()
        let date = date
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let addrequest = {
            let content = UNMutableNotificationContent()
            content.title = "Bill \(bill.name)"
            content.subtitle = bill.billPrice
            content.sound = UNNotificationSound.defaultCritical
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        }
        center.getNotificationSettings{ setting in
            if setting.authorizationStatus == .authorized{
                addrequest()
            }else {
                center.requestAuthorization(options: [.alert, .badge, .sound]){
                    success, error in if success{
                        addrequest()
                    }else {
                        print("Doh")
                    }
                }
            }
        }
    }
    func filteredID(userID: String) -> [Bill] {
        let filtered = billList.bills.filter { $0.userID == userID}
        return filtered
    }
}
struct AddBillView: View {
    @EnvironmentObject private var userModel: UserModel
    @EnvironmentObject private var billList: BillList
    @State private var name = ""
    @State private var dateInput = Date()
    @State private var billPrice = ""
    @Binding var showAddBillView: Bool
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    TextField("Title", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding()
                    TextField("amount", text: $billPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding()
                }
                .padding()
                .padding()
                
                DatePicker("Date", selection: $dateInput)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                
            }
            .navigationBarTitle("Add Bill",displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    showAddBillView.toggle()
                }) {
                    Text("Cancle")
                },
                trailing: Button(action: {
                    showAddBillView = false
                    billList.addBill(name: name, billPrice: billPrice, date: dateInput, userID: userModel.id)
                }) {
                    Text("Done")
                })
            
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
            .environmentObject(BillList())
            .environmentObject(UserModel())
    }
}
