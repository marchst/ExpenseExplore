//
//  ReportView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import SwiftUICharts
import SwiftUI

struct ReportView: View {
    @EnvironmentObject private var expenseList: ExpenseList
    @EnvironmentObject private var userModel: UserModel
    var body: some View {
        NavigationView {
            VStack {
                BarChartView(
                    data: ChartData(values: chartDataFactory(date: expenseList.date, type: "Income", expenseList: expenseList)),
                    title: "Income",
                    legend: "Test",
                    style: Styles.barChartMidnightGreenLight,
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "dollarsign.circle")
                )
                .padding()
                
                BarChartView(
                    data: ChartData(values: chartDataFactory(date: expenseList.date, type: "Expense", expenseList: expenseList)),
                    title: "Expense",
                    form: ChartForm.extraLarge,
                    cornerImage: Image(systemName: "bag")
                )
                
                HStack {
                    Text("Income").bold()
                    Spacer()
                    Text("\(sumAllAmount(type: "Income", date: expenseList.date, expenseList: expenseList)) ฿").bold()
                        .padding(.trailing)
                }
                .padding()
                HStack {
                    Text("Expense").bold()
                    Spacer()
                    Text("\(sumAllAmount(type: "Expense", date: expenseList.date, expenseList: expenseList)) ฿").bold()
                        .padding(.trailing)
                }
                .padding(.leading)
                .padding(.trailing)
                HStack {
                    Text("Balance").bold()
                    Spacer()
                    Text("\(sumAllAmount(type: "Income", date: expenseList.date, expenseList: expenseList)  - sumAllAmount(type: "Expense", date: expenseList.date, expenseList: expenseList)) ฿").bold()
                        .padding(.trailing)
                }
                .padding()
                .navigationBarTitle("Report")
                .navigationBarItems(
                    trailing:
                        ZStack{
                            Text(formatDate(date: expenseList.date))
                                .foregroundColor(.gray)
                                .bold()
                        }
                        .padding(.top, 100)
                        .padding(.trailing))
                
                


                
            }
            
        }
    }
    func chartDataFactory (date: Date, type: String, expenseList: ExpenseList) -> ([(String, Int)]) {
        var chartData: [(String, Int)] = []
        var startTemp = 1
        var endTemp = 1
        
        let filteredUserID = expenseList.expenses.filter { $0.userID == userModel.userID }
        
        let filteredType = filteredUserID.filter { $0.type == type }
        let formatterMonth = DateFormatter()
        formatterMonth.dateFormat = "MMMM"
        
        let filteredMonth = filteredType.filter { formatterMonth.string(from: $0.date) == formatterMonth.string(from: date)}
        
        let filteredNotShow = filteredMonth.filter { $0.showInReport == "true"}
        
        //find start day of month
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!
        
        //find end day of month
        var components2 = DateComponents()
        components2.month = 1
        components2.second = -1
        let endOfMonth = Calendar(identifier: .gregorian).date(byAdding: components2, to: startOfMonth)!
        
        //set endTemp to last day of fisrt week
        endTemp = findLastDayOfFisrtWeek(firstDay: startOfMonth)
        
        let formatterDayDigit = DateFormatter()
        formatterDayDigit.dateFormat = "d"
        
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "EEEE"
        
        var sum = 0
        for _ in 1...7 {
            sum = 0
            for n in startTemp...endTemp {
                        let filteredInRange = filteredNotShow.filter { formatterDayDigit.string(from: $0.date) == "\(n)"}
                        for m in filteredInRange {
                            if m.amount != "" {
                                sum = sum + Int(m.amount)!
                            }
                        }
            }
            chartData.append(("\(startTemp) - \(endTemp)",sum))
            if endTemp == Int(formatterDayDigit.string(from: endOfMonth))! {
                break
            } else if (endTemp + 1) == Int(formatterDayDigit.string(from: endOfMonth))! {
                startTemp = Int(formatterDayDigit.string(from: endOfMonth))!
                endTemp = Int(formatterDayDigit.string(from: endOfMonth))!
            } else if (endTemp + 7) > Int(formatterDayDigit.string(from: endOfMonth))! {
                startTemp = endTemp + 1
                endTemp = Int(formatterDayDigit.string(from: endOfMonth))!
            } else {
                startTemp = endTemp + 1
                endTemp = endTemp + 7
            }
        }
        return chartData
    }
    
    func findLastDayOfFisrtWeek (firstDay: Date) -> (Int) {
        var lastday = 1
        var nowDate = firstDay
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "EEEE"
        
        var dayComponent = DateComponents()
        dayComponent.day = 1
        for _ in 1...7 {
            if formatterDay.string(from: nowDate) != "Sunday" {
                lastday = lastday + 1
                nowDate = Calendar.current.date(byAdding: dayComponent, to: nowDate)!
            } else {
                break
            }
        }
        return lastday
    }
    
    func sumAllAmount (type: String, date: Date, expenseList: ExpenseList) -> Int {
        var allAmount = 0
        
        let filteredUserID = expenseList.expenses.filter { $0.userID == userModel.userID }
        
        let filteredNotShow = filteredUserID.filter { $0.showInReport == "true"}
        
        let formatterMonth = DateFormatter()
        formatterMonth.dateFormat = "MMMM"
        let filteredMonth = filteredNotShow.filter { formatterMonth.string(from: $0.date) == formatterMonth.string(from: date)}
        
        if type == "Income" {
            let filteredType = filteredMonth.filter { $0.type == type }
            for n in filteredType {
                if n.amount != "" {
                    allAmount = allAmount + Int(n.amount)!
                }
            }
        } else if type == "Expense" {
            let filteredType = filteredMonth.filter { $0.type == type }
            for n in filteredType {
                allAmount = allAmount + Int(n.amount)!
            }
        } else {
            for n in filteredMonth {
                allAmount = allAmount + Int(n.amount)!
            }
        }
        return allAmount
    }
    
    func formatDate(date: Date) -> (String) {
        let formatterMonthYear = DateFormatter()
        formatterMonthYear.dateFormat = "MMMM YYYY"
        return formatterMonthYear.string(from: date)
    }
}


struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
            .environmentObject(ExpenseList())
            .environmentObject(UserModel())
    }
}
