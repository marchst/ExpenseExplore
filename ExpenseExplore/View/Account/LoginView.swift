//
//  LoginView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 12/5/2564 BE.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userModel: UserModel
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingResultAlert = false
    var body: some View {
        ZStack {
            VStack {
                Text("Log in")
                    .font(.largeTitle).bold()
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .frame(width: 250, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .frame(width: 250, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                Button (action: {
                    userModel.login(email: email, password: password)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        userModel.loadUserData()
                        showingResultAlert.toggle()
                    }
                }, label: {
                    Text("Login")
                })
                .padding(.top, 30)
                
                .alert(isPresented: $showingResultAlert) {
                    Alert(title: Text(userModel.alertTitleLogin), message: Text(userModel.alertTextLogin),
                          dismissButton: .cancel(Text("OK")) {
                            if userModel.isLoginSuccessful {
                                presentationMode.wrappedValue.dismiss()
                                userModel.isLoginSuccessful = false
                                userModel.alertTitleLogin = ""
                                userModel.alertTextLogin = ""
                            }
                          }
                    )
                }
            }
            .padding()
            .padding(.top,-50)
            .background(Image("IMG_99535")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            
            
        }
        
        
        
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserModel())
    }
}
