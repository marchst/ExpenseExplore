//
//  SignUpView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 13/5/2564 BE.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var userModel: UserModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingResultAlert = false
    var body: some View {
        ZStack {
            VStack {
                Text("Register")
                    .font(.largeTitle).bold()
                    .padding()
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .frame(width: 250, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                TextField("Surname", text: $surname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .frame(width: 250, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                    userModel.addUser(email: email, password: password, name: name, surname: surname)
                    showingResultAlert.toggle()
                }, label: {
                    Text("Sign up")
                        .padding()
                })
                
                .alert(isPresented: $showingResultAlert) {
                    Alert(title: Text(userModel.alertTitleSignUp), message: Text(userModel.alertTextSignUp),
                          dismissButton: .cancel(Text("OK")) {
                            userModel.addUserData()
                            if userModel.isSignUpSuccessful {
                                presentationMode.wrappedValue.dismiss()
                                userModel.isSignUpSuccessful = false
                                userModel.alertTitleSignUp = ""
                                userModel.alertTextSignUp = ""
                            }
                          }
                    )
                }
                
            }
            .padding()
            .padding(.top,-50)
            .background(Image("IMG_99534")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        }
        
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserModel())
    }
}
