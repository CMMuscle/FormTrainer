//
//  ForgetViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/06.
//

import SwiftUI
import FirebaseAuth

class ForgetViewModel: ObservableObject {
    
    // alert表示
    @Published var showingAlert: AlertItem?
    
    @Published var sucess = false
    
    let screen = UIScreen.main.bounds
    
    @Published var mail = ""
    
    // インゲージを表示
    @Published var viewChange = false
    
    let mailText = "[^a-zA-Z0-9@.-_]"
    
    // passwordをリセット
    func resetPassword(){
        if mail == "" { // メールが空白
            print("m空欄")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが空欄です")))
        } else if mail.range(of: mailText, options: .regularExpression, range: nil, locale: nil) != nil {
            print("mdame")
            self.showingAlert = AlertItem(alert: Alert(title: Text("メールアドレスが不適切です")))
        } else {
            Auth.auth().sendPasswordReset(withEmail: mail) { error in
                if error != nil {
                    print(error!.localizedDescription)
                    if error!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.showingAlert = AlertItem(alert: Alert(title: Text("このメールアドレスは登録されていない、もしくは削除されている可能性があります\nもう一度確認の上お試しください")))
                    } else {
                        self.showingAlert = AlertItem(alert: Alert(title: Text("不明なエラーが発生しました")))
                    }
                } else {
                    print("送信完了")
                    
                    self.sucess = true
                    
                }
            }
        }
    }
}
