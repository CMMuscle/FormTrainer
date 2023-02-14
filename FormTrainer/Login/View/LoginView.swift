//
//  LoginView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/28.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginViewModel: LoginViewModel
    @State private var showing: AlertItem?
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
                    if loginViewModel.viewChange {
                        
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
                        .frame(width: loginViewModel.screen.width * 0.84, height: loginViewModel.screen.height * 0.27)
                        .cornerRadius(49)
                }
                .onTapGesture {
                    focus = false
                    
                }
                
                Spacer()
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: loginViewModel.screen.width * 0.84, height: loginViewModel.screen.height * 0.05)
                    if loginViewModel.viewChange {
                        Text(loginViewModel.mail.isEmpty ? "メールアドレス" : loginViewModel.mail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(loginViewModel.mail.isEmpty ? 0.3 : 1.0)
                            .padding(EdgeInsets(top: 0, leading: loginViewModel.screen.width * 0.11, bottom: 0, trailing: 0))
                            .focused($focus)
                            
                    } else {
                        TextField("メールアドレス", text: $loginViewModel.mail)
                            .padding(EdgeInsets(top: 0, leading: loginViewModel.screen.width * 0.11, bottom: 0, trailing: 0))
                            .focused($focus)
                            .keyboardType(UIKeyboardType.emailAddress)
                            .autocapitalization(.none)
                    }
                }
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: loginViewModel.screen.width * 0.84, height: loginViewModel.screen.height * 0.05)
                        .padding()
                    if loginViewModel.viewChange {
                        Text(loginViewModel.password.isEmpty ? "パスワード" : loginViewModel.passwordCheck(pass: loginViewModel.password))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(loginViewModel.password.isEmpty ? 0.3 : 1.0)
                            .padding(EdgeInsets(top: 0, leading: loginViewModel.screen.width * 0.11, bottom: 0, trailing: 0))
                            .font(.system(size: 11))
                            .focused(self.$focus)
                    } else {
                        SecureField("パスワード", text: $loginViewModel.password)
                            .padding(EdgeInsets(top: 0, leading: loginViewModel.screen.width * 0.11, bottom: 0, trailing: 0))
                            .focused(self.$focus)
                            .autocapitalization(.none)
                    }
                }
                if loginViewModel.viewChange {
                    Text("ログイン")
                        .foregroundColor(.white)
                        .frame(width: loginViewModel.screen.width * 0.84, height: loginViewModel.screen.height * 0.05)
                        .background(Color("purple"))
                        .cornerRadius(28)
                } else {
                    Button(action: {
                        focus = false
                        loginViewModel.login()
                        loginViewModel.viewChange = true
                        DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 3.5) {
                            if loginViewModel.sucess {
                                loginViewModel.showingAlert = AlertItem(alert: Alert(title: Text("ログインしました"), dismissButton: .default(Text("OK"),action: {
                                    loginViewModel.menuModal = true
                                })))
                            }
                            showing = loginViewModel.showingAlert
                            loginViewModel.viewChange = false
                        }
                    }, label: {
                        Text("ログイン")
                            .foregroundColor(.white)
                            .frame(width: loginViewModel.screen.width * 0.84, height: loginViewModel.screen.height * 0.05)
                            .background(Color("purple"))
                            .cornerRadius(28)
                    })
                    .fullScreenCover(isPresented: $loginViewModel.menuModal) {
                        MenuView(loginViewModel: loginViewModel)
                    }
                }
                if loginViewModel.viewChange {
                    Text("パスワードを忘れた方はこちら")
                        .foregroundColor(Color(red: 0, green: 0.82, blue: 1))
                        .padding()
                        .underline()
                } else {
                    Button(action: {
                        focus = false
                        loginViewModel.showingModal = true
                    }, label: {
                        Text("パスワードを忘れた方はこちら")
                            .foregroundColor(Color(red: 0, green: 0.82, blue: 1))
                            .padding()
                            .underline()
                    })
                    .alert(item: $showing) { alert in
                        alert.alert
                    }
                    .sheet(isPresented: $loginViewModel.showingModal) {
                        ForgetView(showingModal: $loginViewModel.showingModal)
                    }
                }
                Spacer()
                
                
            }
            
            if loginViewModel.viewChange {
                
                    ProgressView()
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

