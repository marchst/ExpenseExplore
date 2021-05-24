//
//  AccountView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 4/5/2564 BE.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var userModel: UserModel
    @State private var isLogin = false
    @State private var action: Int? = 0
    @State private var showingResultAlert = false
    @State private var listViewId = UUID()
    var body: some View {
        NavigationView {
            VStack {
                if userModel.isLogin {
                    HStack{
                        Spacer()
                        VStack{
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                            Text(userModel.getName() + " " + userModel.getSurname())
                                .font(.title)
                                .bold()
                            Text(userModel.getEmail())
                                .font(.caption)
                                .foregroundColor(.gray)
                                .bold()
                        }
                        .padding()
                        .padding()
                        Spacer()
                    }.navigationBarTitle("Account")
                    .padding()
                    .animation(.linear)
                } else {
                    HStack {
                        NavigationLink( destination: SignUpView(), tag: 2, selection: $action){
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                VStack {
                                    Image(systemName: "person.crop.circle.fill.badge.plus")
                                        .padding(.bottom, 0.5)
                                        .foregroundColor(.white)
                                    Text("Sign up")
                                        .foregroundColor(.white)
                                        .font(.caption).bold()
                                        .onTapGesture {
                                            self.action = 2
                                        }
                                }
                            }
                        }
                        .padding()
                        NavigationLink( destination: LoginView(), tag: 1, selection: $action){
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                VStack {
                                    Image(systemName: "key.fill")
                                        .padding(.bottom, 0.5)
                                        .foregroundColor(.white)
                                    Text("Sign in")
                                        .foregroundColor(.white)
                                        .font(.caption).bold()
                                        .onTapGesture {
                                            self.action = 1
                                        }
                                }
                            }
                        }
                        
                    }
                    .padding()
                    .animation(.easeIn)
                }
                
                List {
                    NavigationLink( destination: SettingView(isLogin: userModel.isLogin, name: userModel.getName(), surname: userModel.getSurname()), tag: 3, selection: $action) {
                        HStack {
                            Image(systemName: "gearshape")
                            Text("Setting")
                            
                        }
                    }
                    if userModel.isLogin {
                        Button(action: {
                            showingResultAlert.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "arrow.right.doc.on.clipboard")
                                    .foregroundColor(.red)
                                Text("Log out")
                            }
                        })
                    }
                }
                .id(listViewId)
                .onAppear {
                    if action != nil {
                        action = nil
                        listViewId = UUID()
                    }
                }
                .navigationBarTitle("Account")
                .animation(.default)
                .alert(isPresented: $showingResultAlert) {
                    Alert(title: Text("Log out"), message: Text("Are you sure?"),
                          primaryButton: .destructive(Text("OK")) {
                            userModel.logout()
                          },secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(UserModel())
    }
}
