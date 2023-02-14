//
//  SettingView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2023/01/17.
//

import SwiftUI
import Firebase


struct SettingView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var menuViewModel: MenuViewModel
    @StateObject var initalViewModel = InitialViewModel()
    @State var showing: AlertItem?
    var body: some View {
        ZStack {
            
            List {
                Section {
                    NavigationLink(destination: ChangeAccount()) {
                        Text("アカウント情報変更")
                            
                    }
                    .listRowBackground(Color(red: 0.50, green: 0.50, blue: 0.50))
                        Text("退会")
                            .foregroundColor(.white)
                            .onTapGesture {
                                showing = AlertItem(alert: Alert(title: Text("退会しますか?"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .destructive(Text("退会"), action: {
                                        Auth.auth().currentUser?.delete()
                                        showing = AlertItem(alert: Alert(title: Text("退会しました"), dismissButton: .default(Text("OK"), action: {
                                                loginViewModel.loginAuth = false
                                        })))
                                })))
                            }
                            .alert(item: $showing) { alert in
                                alert.alert
                            }
                    .listRowBackground(Color(red: 0.50, green: 0.50, blue: 0.50))
                } header: {
                    Text("アカウント設定")
                        .foregroundColor(Color.white)
                }
                
                Section {
                    Text("リセット")
                        .foregroundColor(.white)
                        .onTapGesture {
                            showing = AlertItem(alert: Alert(title: Text("リセットしますか?"), message: Text("今までのトレーニング統計やランクがリセットされます"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .destructive(Text("リセット"), action: {
                                initalViewModel.registrationUser(menuViewModel: menuViewModel, name: menuViewModel.datas!.date.week[0].user.name, weight: menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.weight[menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.weight.count - 1].weight, fat: menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.peopleFat[menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.peopleFat.count - 1].peopleFat, startImage: menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.pictureData.startDownloadURL, viewModel: FilterContentViewModel())
                                showing = AlertItem(alert: Alert(title: Text("リセットしました"), dismissButton: .default(Text("OK"))))
                            })))
                        }
                        .alert(item: $showing) { alert in
                            alert.alert
                        }
                        .listRowBackground(Color(red: 0.50, green: 0.50, blue: 0.50))
                    
                } header: {
                    Text("記録・ミッション設定")
                        .foregroundColor(Color.white)
                }
                
                Section {
                    Text("SNSでシェアする")
                        .foregroundColor(.white)
                        .listRowBackground(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .onTapGesture {
                            settingViewModel.sharePost(shareText: "本日の筋トレ\nプランク\(menuViewModel.todayCount[0].Count)秒\nバックスクワット\(menuViewModel.todayCount[1].Count)回\n腹筋\(menuViewModel.todayCount[2].Count)回\nサイドプランク\(menuViewModel.todayCount[3].Count)秒\n背筋\(menuViewModel.todayCount[4].Count)回\n腕立て\(menuViewModel.todayCount[5].Count)回", shareImage: Image("icon"), shareUrl: "")
                        }
                } header: {
                    Text("シェア")
                        .foregroundColor(.white)
                }
                
            }
            .scrollContentBackground(.hidden)
            .padding(EdgeInsets(top: settingViewModel.screen.height * 0.035, leading: 0, bottom: 0, trailing: 0))
            
            .background(Color(red: 0.43, green: 0.43, blue: 0.43))
        }
    }
}

