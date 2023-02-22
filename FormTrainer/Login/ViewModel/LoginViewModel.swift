//
//  LoginViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/06.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var viewChange = false
    
    @Published var showingModal = false
    @Published var auth = false
    
    let screen = UIScreen.main.bounds
    
    @Published var mail = ""
    @Published var password = ""
    @Published var subPassword = ""
    
    
    
    @Published var menuModal = false
    
    @Published var sucess = false
    
    @Published var firstAuth = true
    
    @AppStorage("login") var loginAuth = false
    
    @Published var showingAlert = AlertItem(alert: Alert(title: Text("ネットワーク接続を確認してください")))
    
    let mailText = "[^a-zA-Z0-9@.-_]"
    let passwordText = "[^a-zA-Z0-9]"
    
    
    
    func passwordCheck(pass: String) -> String {
        let count = pass.count
        var password = ""
        for _ in 0..<count {
            password.append("●")
        }
        return password
    }
    
    func login() {
        if mail == "" { // メールが空白
            print("m空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが空欄です")))
        } else if password == "" { // パスワード空白
            print("p空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが空欄です")))
        } else if mail.range(of: mailText, options: .regularExpression, range: nil, locale: nil) != nil { // メールの形式が異なる
            print("mだめ")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが不適切です")))
        }  else if password.range(of: passwordText, options: .regularExpression, range: nil, locale: nil) != nil {
            print("pだめ")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが不適切です")))
        } else if password.count < 8 {
            print("8p")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードは最小8文字からです")))
        } else {
            Auth.auth().signIn(withEmail: mail, password: password) { result, error in
                if let user = result?.user {
                    if user.isEmailVerified {
                        print("メールアドレス確認済み")
                        self.sucess = true
                        self.loginAuth = true
                    } else {
                        print("メールアドレス未確認")
                        self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレス認証がまだ済んでいません\nメールボックスをご確認ください")))
                    }
                } else {
                    print(error!.localizedDescription)
                    if error!.localizedDescription == "The email address is badly formatted." {
                        print("damepppp")
                        self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが不適切です")))
                    } else if error!.localizedDescription == "The password is invalid or the user does not have a password." {
                        print("dd")
                        self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスまたはパスワードが違います")))
                    } else if error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが登録されていません")))
                    }
                }
            }
        }
    }
}
