//
//  ChangeAccount.swift
//  Muscle
//
//  Created by 稗田一亜 on 2023/01/18.
//

import SwiftUI

struct ChangeAccount: View {
    
    @StateObject var changeAccountModel = ChangeAccountModel()
    @FocusState var focus: Bool
    @State var showing: AlertItem?
    
    var body: some View {
        
        ZStack {
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
                .onTapGesture {
                    focus = false
                }
            VStack {
                
                Text("変更しないものは現在の情報を入力してください")
                    .padding(EdgeInsets(top: changeAccountModel.screen.height * 0.035, leading: 0, bottom: 0, trailing: 0))
                
                // 名前
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: changeAccountModel.screen.width * 0.84, height: changeAccountModel.screen.height * 0.05)
                    
                    TextField("新しい名前", text: $changeAccountModel.name)
                        .padding(EdgeInsets(top: 0, leading: changeAccountModel.screen.width * 0.11, bottom: 0, trailing: 0))
                        .focused($focus)
                        .keyboardType(UIKeyboardType.emailAddress)
                }
                
                
                
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: changeAccountModel.screen.width * 0.84, height: changeAccountModel.screen.height * 0.05)
                    
                    TextField("新しいメールアドレス", text: $changeAccountModel.mail)
                        .padding(EdgeInsets(top: 0, leading: changeAccountModel.screen.width * 0.11, bottom: 0, trailing: 0))
                        .focused($focus)
                        .keyboardType(UIKeyboardType.emailAddress)
                }
                
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: changeAccountModel.screen.width * 0.84, height: changeAccountModel.screen.height * 0.05)
                    
                    TextField("新しいパスワード", text: $changeAccountModel.pass)
                        .padding(EdgeInsets(top: 0, leading: changeAccountModel.screen.width * 0.11, bottom: 0, trailing: 0))
                        .focused($focus)
                        .keyboardType(UIKeyboardType.emailAddress)
                }
                
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: changeAccountModel.screen.width * 0.84, height: changeAccountModel.screen.height * 0.05)
                    
                    TextField("新しいパスワード（確認）", text: $changeAccountModel.repass)
                        .padding(EdgeInsets(top: 0, leading: changeAccountModel.screen.width * 0.11, bottom: 0, trailing: 0))
                        .focused($focus)
                        .keyboardType(UIKeyboardType.emailAddress)
                }
                
                Spacer()
                
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: changeAccountModel.screen.width * 0.84, height: changeAccountModel.screen.height * 0.05)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: changeAccountModel.screen.height * 0.035, trailing: 0))
                    if changeAccountModel.progress {
                        Text("保存")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: changeAccountModel.screen.height * 0.035, trailing: 0))
                            .focused($focus)
                    } else {
                        Button("保存") {
                            changeAccountModel.updateData()
                            changeAccountModel.progress = true
                            DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 3.5) {
                                changeAccountModel.progress = false
                                showing = changeAccountModel.showingAlert
                                print(showing)
                                print("pass\(changeAccountModel.pass)")
                                print("repa\(changeAccountModel.repass)")
                            }
                        }
                        .alert(item: $showing) { alert in
                            alert.alert
                        }
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: changeAccountModel.screen.height * 0.035, trailing: 0))
                        .focused($focus)
                    }
                }
            }
            
            if changeAccountModel.progress {
                ProgressView()
            } else {
                
            }
        }
    }
}


struct ChangeAccount_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAccount()
    }
}
