//
//  UserModel.swift
//  ExpenseExplore
//
//  Created by Surapunya Thongdee on 12/5/2564 BE.
//

import SwiftUI
import FirebaseAuth
import Firebase

class UserModel: ObservableObject {
    
    @AppStorage("isLogin") var isLogin = false
    @Published var isSignUpSuccessful = false
    @Published var isLoginSuccessful = false
    @Published var alertTextSignUp: String = ""
    @Published var alertTitleSignUp: String = ""
    @Published var alertTitleLogin: String = ""
    @Published var alertTextLogin: String = ""
    @AppStorage("userID") var userID: String = ""
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userSurname") private var userSurname: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("currency") var currency: String = ""
    
    @Published var id: String = ""
    
    @AppStorage("isSetPass") var isSetPass: Bool = false
    @AppStorage("checkPass") var checkPass: Bool = true
    @AppStorage("passcode") var passcode: String = ""
    
    private let collectionName = "users"
    private let userDB = Firestore.firestore()
    
    func addUser(email: String, password: String, name: String, surname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                    print("ⓧ Register error: \(error.localizedDescription).")
                    self.alertTitleSignUp = "ⓧ Register error"
                    self.alertTextSignUp = "\(error.localizedDescription)."
                  } else {
                    print("✔ Register was successful.")
                    self.alertTextSignUp = "✔ Register was successful"
                    self.isSignUpSuccessful = true
                    self.userID = (authResult?.user.uid)!
                    self.userName = name
                    self.userSurname = surname
                  }
            }
    }
    
    func addUserData() {
        userDB.collection(collectionName).addDocument(data: [
            "name": userName,
            "surname": userSurname,
            "userID": userID
        ])
        self.userID = ""
        self.userName = ""
        self.userSurname = ""
    }
    
//    func updateUserData(id: String, name: String, surname: String, userID: String) {
//        userDB.collection(collectionName).document(id).updateData([
//            "name": name,
//            "surname": surname,
//            "userID": userID
//        ]) { error in
//            print(error ?? "Update failed.")
//        }
//        loadUserData()
//    }
//    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                    print("ⓧ Authentication error: \(error.localizedDescription).")
                    self.alertTitleLogin = "ⓧ Authentication error"
                    self.alertTextLogin = "\(error.localizedDescription)."
                  } else {
                    print("✔ Authentication was successful.")
                    self.isLogin = true
                    self.isLoginSuccessful = true
                    self.id = (authResult?.user.uid)!
                    self.userEmail = (authResult?.user.email)!
                    self.alertTitleLogin = ""
                    self.alertTextLogin = "✔ Authentication was successful"
                  }
        }
    }
    
    func loadUserData() {
        userDB.collection(collectionName).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard  let name = data["name"] as? String,
                           let surname = data["surname"] as? String,
                           let userID = data["userID"] as? String
                    else {
                        return
                    }
                    if userID == self.id {
                        self.userName = name
                        self.userSurname = surname
                        self.userID = self.id
                    }   
                }
            }
        }
    }
    
    func getName() -> (String) {
        return userName
    }
    
    func getSurname() -> (String) {
        return userSurname
    }
    
    func getEmail() -> (String) {
        return userEmail
    }
    
    func checkPass(pin: String) {
        if passcode == pin {
            checkPass = true
        }
    }
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLogin = false
            self.userID = ""
            self.userName = ""
            self.userSurname = ""
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }

}

