//
//  ResetView.swift
//  FormTrainer
//
//  Created by 稗田一亜 on 2023/02/12.
//

import SwiftUI

struct ResetView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var menuViewModel: MenuViewModel
    @State var showing: AlertItem?
    var body: some View {
        ZStack {
            
            List {
                Section {
                    NavigationLink(destination: ChangeAccount()) {
                        Text("アカウント情報変更")
                        
                    }
                    .listRowBackground(Color(red: 0.50, green: 0.50, blue: 0.50))
                    
                }
                
                Section {
                    NavigationLink(destination: ChangeAccount()) {
                        Text("リセット")
                            .foregroundColor(.white)
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

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView()
    }
}
