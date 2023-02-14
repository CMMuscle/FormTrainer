//
//  SideMenuView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/25.
//

import SwiftUI
import FirebaseAuth

struct SideMenuView: View {
    @StateObject var sideMenuViewModel = SideMenuViewModel()
    @ObservedObject var menuViewModel: MenuViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @State var showing: AlertItem?
    
    var body: some View {
        ZStack {
            HStack {
                VStack(spacing: 0) {
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 0.31, green: 0.31, blue: 0.31))
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.32)
                        
                        Image("icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                            .padding(EdgeInsets(top: UIScreen.main.bounds.height * 0.01, leading: 0, bottom: 0, trailing: 0))
                    }
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.white),
                                alignment: .bottom
                            )
                        
                        Text(menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.name)
                            .foregroundColor(.white)
                    }
                    
                    Rectangle()
                        .fill(Color(red: 0.43, green: 0.43, blue: 0.43))
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.15)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.white),
                            alignment: .bottom
                        )
                    
                    NavigationLink(destination: UserView(menuViewModel: menuViewModel)) {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.white),
                                    alignment: .bottom
                                )
                            
                            Text("ユーザー情報")
                                .foregroundColor(.white)
                        }
                    }
                    
                    NavigationLink(destination: MainDataView(menuViewModel: menuViewModel)) {
                        ZStack {
                            
                            Rectangle()
                                .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.white),
                                    alignment: .bottom
                                )
                            
                            Text("統計")
                                .foregroundColor(.white)
                        }
                    }
                    NavigationLink(destination: MissionView(menuViewModel: menuViewModel)) {
                        ZStack {
                            
                            Rectangle()
                                .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.white),
                                    alignment: .bottom
                                )
                            Text("ミッション")
                                .foregroundColor(.white)
                        }
                    }
                    
                    NavigationLink(destination: TrainingSettingView(menuViewModel: menuViewModel)) {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.white),
                                    alignment: .bottom
                                )
                            
                            Text("トレーニング設定")
                                .foregroundColor(.white)
                        }
                    }
                    Rectangle()
                        .fill(Color(red: 0.43, green: 0.43, blue: 0.43))
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.10)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.white),
                            alignment: .bottom
                        )
                    
                    NavigationLink(destination: SettingView(loginViewModel: loginViewModel, menuViewModel: menuViewModel)) {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.white),
                                    alignment: .bottom
                                )
                            
                            Text("設定")
                                .foregroundColor(.white)
                        }
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 0.43, green: 0.35, blue: 0.66))
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.white),
                                alignment: .bottom
                            )
                        Button {
                            showing = AlertItem(alert: Alert(title: Text("ログアウトしますか?"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .destructive(Text("ログアウト"), action: {
                                do {
                                    try Auth.auth().signOut()
                                    showing = AlertItem(alert: Alert(title: Text("ログアウトしました"), dismissButton: .default(Text("OK"), action: {
                                            loginViewModel.loginAuth = false
                                    })))
                                } catch {
                                    print("Error signing out: %@")
                                }
                            })))
                        } label: {
                            Text("ログアウト")
                                .foregroundColor(.white)
                        }
                        .alert(item: $showing) { alert in
                            alert.alert
                        }
                    }
                }
                
                Spacer()
                
            }
        }
    }
}

