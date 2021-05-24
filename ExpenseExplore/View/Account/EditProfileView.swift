////
////  EditProfileView.swift
////  ExpenseExplore
////
////  Created by Surapunya Thongdee on 21/5/2564 BE.
////
//
//import SwiftUI
//
//struct EditProfileView: View {
//    @EnvironmentObject private var userModel: UserModel
//    @State var id: String
//    @State var name: String
//    @State var surname: String
//    @State var userID: String
//    @Binding var showEditProfileView: Bool
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("")
//                    .padding()
//                ScrollView {
//                    TextField("Name", text: $name)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                        .frame(width: 250, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                        .padding()
//                    TextField("Surname", text: $surname)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                        .frame(width: 250, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                        .padding()
//                }
//                Button(action: {
//                    showEditProfileView.toggle()
//                    userModel.updateUserData(id: id, name: name, surname: surname, userID: userID)
//                }, label: {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 15)
//                            .frame(width: 150, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                        Text("Done").bold()
//                            .foregroundColor(.white)
//                    }
//                }).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                .navigationBarTitle("Edit Profile", displayMode: .inline)
//            }
//        }
//        
//    }
//}
//
//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(id: "",name: "", surname: "", userID: "", showEditProfileView: .constant(true))
//            .environmentObject(UserModel())
//    }
//}
