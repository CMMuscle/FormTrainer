//
//  SignUpView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/28.
//

import SwiftUI
import Combine

struct SignUpView: View {
    let screen = UIScreen.main.bounds
    
    @StateObject var SignUpModel = SignUpViewModel()
    @ObservedObject var loginViewModel: LoginViewModel
    @State var showing: AlertItem?
    @Environment(\.dismiss) var dismiss
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
                .onTapGesture {
                    focus = false
                }
            
            VStack {
                
                HStack {
                    if SignUpModel.viewChange {
                       
                            Text("<")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                        
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Text("<")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                        }
                    }
                    
                    Spacer()

                }
                
                ZStack {
                    Image("FormTrainer")
                        .resizable()
                        .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                        .cornerRadius(49)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                }
                .onTapGesture {
                    focus = false
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    if SignUpModel.viewChange {
                        Text(SignUpModel.mail.isEmpty ? "メールアドレス" : SignUpModel.mail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .opacity(SignUpModel.mail.isEmpty ? 0.3 : 1.0)
                            .focused(self.$focus)
                    } else {
                        TextField("メールアドレス", text: $SignUpModel.mail)
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .focused(self.$focus)
                            .keyboardType(UIKeyboardType.emailAddress)
                            .autocapitalization(.none)
                    }
                }
                
                Text("受信できるメールアドレスを使用してください")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    
                    if SignUpModel.viewChange {
                        Text(SignUpModel.password.isEmpty ? "パスワード" : SignUpModel.passwordCheck(pass: SignUpModel.password))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(SignUpModel.password.isEmpty ? 0.3 : 1.0)
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .font(.system(size: 11))
                            .focused(self.$focus)
                    } else {
                        SecureField("パスワード", text: $SignUpModel.password)
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .focused(self.$focus)
                            .autocapitalization(.none)
                    }
                }
                
                Text("英数字記号(. _ -)8文字以上のみ使用可能")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    
                    if SignUpModel.viewChange {
                        Text(SignUpModel.subPassword.isEmpty ? "パスワード（確認用）" : SignUpModel.passwordCheck(pass: SignUpModel.subPassword))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(SignUpModel.subPassword.isEmpty ? 0.3 : 1.0)
                            .font(.system(size: 11))
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .focused(self.$focus)
                    } else {
                        SecureField("パスワード（確認用）", text: $SignUpModel.subPassword)
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .focused(self.$focus)
                            .autocapitalization(.none)
                    }
                    
                }
                if SignUpModel.viewChange {
                    Text("登録")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                        .background(Color("purple"))
                        .cornerRadius(28)
                        .padding()
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                } else {
                    
                    Button(action: {
                        focus = false
                        SignUpModel.signUp()
                        SignUpModel.viewChange = true
                        print("auth\(loginViewModel.auth)")
                        DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 3.5) {
                            showing = SignUpModel.showingAlert
                            SignUpModel.viewChange = false
                            print("auth\(loginViewModel.auth)")
                        }
                        
                        
                    }, label: {
                        Text("登録")
                            .foregroundColor(.white)
                            .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                            .background(Color("purple"))
                            .cornerRadius(28)
                            .padding()
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    })
                    .alert(item: $showing) { alert in
                        alert.alert
                    }
                }
                Spacer()
                
            }
            if SignUpModel.viewChange {
                ProgressView()
            } else {
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}



