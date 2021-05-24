//
//  SettingView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 13/5/2564 BE.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var userModel: UserModel
    @State private var showSetPasscodeView: Bool = false
    @State private var showEditProfileView: Bool = false
    @State private var showPicker = false
    @State private var currency = ""
    @State var isLogin: Bool
    @State var name: String
    @State var surname: String
    
    var curr = ["$","€","¥","£","฿","₩","₹"]
    
    
    var body: some View {
        ScrollView {
            Text("")
            HStack {
                Image(systemName: "lock")
                Toggle(isOn: $userModel.isSetPass) {
                    Text("Set passcode")
                }
                .onChange(of: userModel.isSetPass, perform: { value in
                    if userModel.isSetPass == true {
                        showSetPasscodeView = true
                        userModel.checkPass = true
                    }
                    if userModel.isSetPass == false {
                        userModel.checkPass = true
                        userModel.passcode = ""
                    }
                })
                
            }
            .padding()
            
            Button(action: {
                showPicker.toggle()
            }, label: {
                HStack {
                    Image(systemName: "banknote")
                    Text("Change currency icon")
                    Spacer()
                    Text(userModel.currency)
                        .padding(.trailing, 10)
                }
            })
            .animation(.default)
            .foregroundColor(.black)
            
            
            
            .padding()
            .navigationBarTitle("Setting",displayMode: .inline)
            .sheet(isPresented: $showSetPasscodeView) {
                SetPasscodeView(showSetPasscodeView: $showSetPasscodeView)
                
            }
            if showPicker {
                VStack {
                    Spacer()
                    Picker("Event", selection: $currency) {
                        ForEach(curr,id: \.self) { cur in
                            Text(cur)
                        }
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    Button(action: {
                        showPicker.toggle()
                        setCurrency()
                    }, label: {
                        Text("OK").bold()
                    })
                    .padding()
                    .padding()
                    .animation(.default)
                }
                
            }
            
            
        }
    }
    func setCurrency() {
        userModel.currency = self.currency
    }
    
}

struct SetPasscodeView: View {
    @EnvironmentObject private var userModel: UserModel
    @Binding var showSetPasscodeView: Bool
    @State private var passcode: String = ""
    var body: some View {
        Text("Setup your passcode")
        VStack{
            TextField("", text: $passcode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
            Button(action: {
                showSetPasscodeView.toggle()
                userModel.passcode = passcode
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    userModel.checkPass = true
                }
                
            }, label: {
                Text("Submit")
            })
            .padding()
        }
        .padding()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(isLogin: true, name: "",surname: "")
            .environmentObject(UserModel())
    }
}
