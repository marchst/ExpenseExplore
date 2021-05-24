//
//  PlanningView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import SwiftUI

struct PlanningView: View {
    @State private var action: Int? = 0
    @State private var listViewId = UUID()
    var body: some View {
        NavigationView {
            List {
                NavigationLink( destination: EventView(), tag: 1, selection: $action){
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("Events")
                    }
                }
                NavigationLink( destination: BillView(), tag: 2, selection: $action){
                    HStack {
                        Image(systemName: "newspaper")
                        Text("Bills")
                    }
                }
                
            }
            .id(listViewId)
            .onAppear {
                if action != nil {
                    action = nil
                    listViewId = UUID()
                }
            }
            .navigationBarTitle("Planning")
            .padding()
        }
    }
}

struct PlanningView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningView()
    }
}
