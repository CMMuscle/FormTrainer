//
//  SignUpViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/01.
//

import FirebaseAuth
import SwiftUI
import Combine



struct AlertItem: Identifiable {
    var id = UUID()
    var alert: Alert
}

class SignUpViewModel: ObservableObject {
    
    @Published var viewChange = false
    
    @Published var mail = ""
    @Published var password = ""
    @Published var subPassword = ""
    
    @Published var showingAlert = AlertItem(alert: Alert(title: Text("アラート１")))    
    
    let mailText = "[^a-zA-Z0-9@.-_]"
    let passwordText = "[^a-zA-Z0-9]"
    
    let screen = UIScreen.main.bounds
    
    func passwordCheck(pass: String) -> String {
        let count = pass.count
        var password = ""
        for _ in 0..<count {
            password.append("●")
        }
        return password
    }
    
    // SignUpを行う
    func signUp(){
        
        if mail == "" { // メールが空白
            print("m空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが空欄です")))
        } else if password == "" { // パスワード空白
            print("p空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが空欄です")))
        } else if mail.range(of: mailText, options: .regularExpression, range: nil, locale: nil) != nil {
            print("mだめ")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが不適切です")))
        }  else if password.range(of: passwordText, options: .regularExpression, range: nil, locale: nil) != nil {
            print("pだめ")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが不適切です")))
        } else if password.count < 8 {
            print("8p")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードは最小8文字からです")))
        } else if password != subPassword {
            print("notp")
            self.showingAlert = AlertItem(alert: Alert(title: Text("パスワードが一致しません")))
        }else {
            Auth.auth().createUser(withEmail: mail, password: password) { result , error in
                if error != nil {
                    print(error!.localizedDescription)
                    if error!.localizedDescription == "The email address is badly formatted." {
                        print("damepppp")
                        self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが不適切です")))
                    } else if error!.localizedDescription == "The email address is already in use by another account." {
                        print("doao;jf;oiaj")
                        self.showingAlert = AlertItem(alert: Alert(title: Text("そのメールアドレスはすでに登録済みです")))
                    }
                } else {
                    print("-==---")
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        print("33333333")
                        self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスの認証をお願いいたします")))
                    }
                    
                }
            }
            
            
        
        }
    }
}

extension String {
    func removingWhiteSpace() -> String {
        let whiteSpaces: CharacterSet = [" ", "　"]
        return self.trimmingCharacters(in: whiteSpaces)
    }
}
