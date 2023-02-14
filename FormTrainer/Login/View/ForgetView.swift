//
//  ForgetView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/29.
//

import SwiftUI

struct ForgetView: View {
    
    @StateObject var forgetViewModel = ForgetViewModel()
    @State private var showing: AlertItem?
    
    @Binding var showingModal: Bool
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            
                
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
                .onTapGesture {
                    focus = false
                }
            VStack {
                
                Spacer()
                
                
                ZStack {
                    Image("FormTrainer")
                        .resizable()
                        .frame(width: forgetViewModel.screen.width * 0.84, height: forgetViewModel.screen.height * 0.27)
                        .cornerRadius(49)
                }
                .onTapGesture {
                    focus = false
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: forgetViewModel.screen.width * 0.84, height: forgetViewModel.screen.height * 0.05)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    
                    if forgetViewModel.viewChange {
                        Text(forgetViewModel.mail.isEmpty ? "メールアドレス" : forgetViewModel.mail)
                            .frame(minWidth: .infinity)
                            .opacity(forgetViewModel.mail.isEmpty ? 0.3 : 1.0)
                            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                            .foregroundColor(.white)
                    } else {
                        
                        TextField("メールアドレス", text: $forgetViewModel.mail)
                        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                        .keyboardType(UIKeyboardType.emailAddress)
                    }
                }
                
                Text("登録されているメールアドレスに送信します")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                
            
                Button(action: {
                    focus = false
                    forgetViewModel.resetPassword()
                    forgetViewModel.viewChange = true
                    
                    DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 1.5) {
                        if forgetViewModel.sucess {
                            forgetViewModel.showingAlert = AlertItem(alert: Alert(title: Text("メールを送信しました"), dismissButton: .default(Text("OK"),action: {
                                showingModal = false
                            })))
                        }
                        showing = forgetViewModel.showingAlert
                        forgetViewModel.viewChange = false
                    }
                    
                }, label: {
                    Text("送信")
                        .foregroundColor(.white)
                        .frame(width: forgetViewModel.screen.width * 0.84, height: forgetViewModel.screen.height * 0.05)
                        .background(Color("purple"))
                        .cornerRadius(28)
                })
                .alert(item: $showing) { alert in
                    alert.alert
                }
                
                Spacer()
                
            }
            if forgetViewModel.viewChange {
                Color(red: 0.43, green: 0.43, blue: 0.43)
                    .frame(width: forgetViewModel.screen.width, height: forgetViewModel.screen.height)
                    .opacity(0.00000000000000001)
                ProgressView()
            }
        }
    }
}
