//
//  PinView.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 13/5/2564 BE.
//

import SwiftUI

struct PinView: View {
    @State var pass: String = ""
    @EnvironmentObject private var userModel: UserModel
    var body: some View {
        VStack{
            Text("Enter your passcode")
            SecureField("", text: $pass)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
                .padding(.leading)
                .padding(.trailing)
            Button(action: {
                userModel.checkPass(pin: pass)
            }, label: {
                Text("Submit").bold()
            })
            .padding()
        }
        .animation(.default)
        .background(Image("IMG_9953")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView()
            .environmentObject(UserModel())
    }
}
