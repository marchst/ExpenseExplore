//
//  ContentView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 3/5/2564 BE.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var userModel: UserModel
    @State private var fadeInOut = false
    
    var body: some View {
        Text("")
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("")
                toggleCheckPass()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("")
                toggleCheckPass()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                print("")
                toggleCheckPass()
            }
        if(!userModel.checkPass) {
            PinView()
        } else {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Home")
                    }
                ReportView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Report")
                    }
                PlanningView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Planning")
                    }
                AccountView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Account")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
            }
            .onAppear(){
                withAnimation(Animation.easeInOut(duration: 0.6)) {
                    fadeInOut = true
                }
            }.opacity(fadeInOut ? 1 : 0)
        }
        
    }
    func toggleCheckPass() {
        if userModel.isSetPass == false {
            userModel.checkPass = true
        } else {
            userModel.checkPass = false
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ExpenseList())
            .environmentObject(UserModel())
    }
}
