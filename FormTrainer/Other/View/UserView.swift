//
//  UserView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2023/01/11.
//

import SwiftUI
import UIKit
import Photos

struct UserView: View {
    
    @State var message = ""
    let screen = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
    @ObservedObject var menuViewModel: MenuViewModel
    @StateObject private var viewModel = FilterContentViewModel()
    
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
    @State var isActionSheet = false
    @State var isImagePicker = false
    var buttons: [ActionSheet.Button] = []
    
    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
            
            VStack{
                
                ZStack {
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                        .frame(width: screen.width * 0.84,
                               height: screen.height * 0.05)
                    
                    HStack{
                        Text("名前")
                            .padding(EdgeInsets(top: 0, leading: screen.width * 0.11, bottom: 0, trailing: 0))
                            .foregroundColor(.white)
                        
                        Spacer()
                        Text(menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.name)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screen.width * 0.11))
                            .foregroundColor(.white)
                    }
                }
                .padding(EdgeInsets(top: screen.height * 0.035, leading: 0, bottom: 0, trailing: 0))
                
                //体重
                ZStack {
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                        .frame(width: screen.width * 0.84,
                               height: screen.height * 0.05)
                    
                    HStack{
                        Text("体重")
                            .padding(EdgeInsets(top: 0, leading: screen.width * 0.11, bottom: 0, trailing: 0))
                            .foregroundColor(.white)
                        
                        Spacer()
                        Text("\(String(format: "%.1f",menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.weight[Calendar.current.component(.weekday, from: Date())-1].weight))kg")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screen.width * 0.11))
                            .foregroundColor(.white)
                    }
                }
                //体脂肪率
                ZStack {
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                        .frame(width: screen.width * 0.84,
                               height: screen.height * 0.05)
                    
                    HStack{
                        Text("体脂肪率")
                            .padding(EdgeInsets(top: 0, leading: screen.width * 0.11, bottom: 0, trailing: 0))
                            .foregroundColor(.white)
                        
                        Spacer()
                        Text("\(String(format: "%.1f",menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.peopleFat[Calendar.current.component(.weekday, from: Date())-1].peopleFat))%")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screen.width * 0.11))
                            .foregroundColor(.white)
                    }
                }
                
                //写真
                ZStack {
                    
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                        .frame(width: screen.width * 0.84,
                               height: screen.height * 0.5)
                    
                    VStack{
                        HStack{
                            Text("写真")
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: screen.width * 0.25)
                        }
                        
                        
                        HStack{
                            Spacer()
                            VStack{
                                ZStack{
                                    
                                    
                                    if let filterdImage = viewModel.startFilteredImage {
                                        Image(uiImage: filterdImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .onTapGesture {
                                                viewModel.filterImage = false
                                                viewModel.isShowActionSheet = true
                                            }
                                        
                                    } else {
                                        if !menuViewModel.datas!.startFirst {
                                            Button("写真追加"){
                                                viewModel.filterImage = false
                                                viewModel.isShowActionSheet = true
                                            }
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        } else {
                                            ProgressView()
                                                .frame(width: screen.width * 0.34, height: screen.height * 0.32)
                                        }
                                    }
                                    
                                    
                                }
                                Text("開始時の体型")
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack{
                                ZStack{
                                    if let filterdImage = viewModel.nowFilteredImage {
                                        Image(uiImage: filterdImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .onTapGesture {
                                                viewModel.filterImage = true
                                                viewModel.isShowActionSheet = true
                                            }
                                        
                                    } else {
                                        if !menuViewModel.datas!.nowFirst {
                                            Button("写真なし"){
                                            }
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        } else {
                                            ProgressView()
                                                .frame(width: screen.width * 0.34, height: screen.height * 0.32)
                                        }
                                    }
                                }
                                
                                Text("現在の体型")
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        
                    }
                    .frame(width: screen.width * 0.84,
                           height: screen.height * 0.5)
                    .padding()
                }
                
                Spacer()
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Text("＜")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    )
                }
            }
            ToolbarItem(placement: .principal) {
                Text("ユーザー情報")
                    .foregroundColor(.white)
                    .font(.largeTitle)

                Spacer()
            }

        }
        
        .onAppear {
            if menuViewModel.datas!.date.week[0].user.pictureData.startDownloadURL != nil {
                print("ytfkugilhoj;")
                viewModel.downloadImageAsync(url: menuViewModel.datas!.date.week[0].user.pictureData.startDownloadURL!) { image in
                    self.viewModel.startFilteredImage = image
                }
                
            }
            if menuViewModel.datas!.date.week[0].user.pictureData.nowDownloadURL != nil {
                viewModel.downloadImageAsync(url: menuViewModel.datas!.date.week[0].user.pictureData.nowDownloadURL!) { image in
                    self.viewModel.nowFilteredImage = image
                }
            }
        }
        
    }
    
    var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                viewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")){
                viewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        let cancelButton = ActionSheet.Button.default(Text("キャンセル")){}
        buttons.append(cancelButton)
        
        let actionSheet = ActionSheet(title: Text("画像選択"),message: nil, buttons: buttons)
        
        return actionSheet
    }
}


