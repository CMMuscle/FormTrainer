//
//  ChangeAccountModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2023/01/19.
//

import Foundation
import UIKit
import FirebaseAuth
import SwiftUI

class ChangeAccountModel: ObservableObject {
    let screen = UIScreen.main.bounds
    
    @Published var name = ""
    @Published var mail = ""
    @Published var pass = ""
    @Published var repass = ""
    
    @Published var showingAlert = AlertItem(alert: Alert(title: Text("ネットワークが不安定です")))
    @Published var progress = false
    
    @Published var viewChange = false
    
    let mailText = "[^a-zA-Z0-9@.-_]"
    let passwordText = "[^a-zA-Z0-9]"
    
    func updateData() {
        if mail == "" { // メールが空白
            print("m空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが空欄です")))
        } else if name == "" {
            self.showingAlert = AlertItem(alert: Alert(title: Text("名前が空欄です")))
        } else if pass == "" { // パスワード空白
            print("p空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが空欄です")))
        } else if mail.range(of: mailText, options: .regularExpression, range: nil, locale: nil) != nil { // メールの形式が異なる
            print("mだめ")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが不適切です")))
        }  else if pass.range(of: passwordText, options: .regularExpression, range: nil, locale: nil) != nil {
            print("pだめ")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが不適切です")))
        } else if pass.count < 8 {
            print("8p")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードは最小8文字からです")))
        } else if pass != repass {
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが一致していません")))
        } else {
            
            
            Auth.auth().currentUser?.updateEmail(to: mail) { error in
                if let error = error {
                    print(error.localizedDescription)
                    if error.localizedDescription == "The email address is already in use by another account." {
                        self.showingAlert = AlertItem(alert: Alert(title: Text("すでにそのメールアドレスは使われています")))
                    }
                    return
                } else {
                    
                }
            }
            Auth.auth().currentUser?.updatePassword(to: pass) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showingAlert = AlertItem(alert: Alert(title: Text("変更しerra")))
                    return
                } else {
                    self.showingAlert = AlertItem(alert: Alert(title: Text("変更しました")))
                }
            }
        }
    }
}
