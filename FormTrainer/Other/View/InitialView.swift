//
//  InitialView.swift
//  FormTrainer
//
//  Created by 稗田一亜 on 2023/02/03.
//

import SwiftUI
import UIKit
import Photos


struct InitialView: View {
    
    @State var message = ""
    let screen = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
    @ObservedObject var menuViewModel: MenuViewModel
    @StateObject private var viewModel = FilterContentViewModel()
    @StateObject private var initialViewModel = InitialViewModel()
    
    @State var changed = false
    
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
    @State var isActionSheet = false
    @State var isImagePicker = false
    var buttons: [ActionSheet.Button] = []
    
    @State var nameRecord = ""
    @State var weightRecord = ""
    @State var fatRecord = ""
    @FocusState var focus: Bool
    let numText = "[0-9.]"
    
    var intFormatter: Formatter = NumberFormatter()
    
    @State var showing: AlertItem?

    var body: some View {
        GeometryReader { _ in
            ZStack {
                // 背景色
                Color(red: 0.43, green: 0.43, blue: 0.43)
                    .ignoresSafeArea()
                    .onTapGesture {
                        focus = false
                    }
                
                VStack{
                    
                    ZStack {
                        // ブロック背景
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                            .frame(width: screen.width * 0.84,
                                   height: screen.height * 0.05)
                            .focused(self.$focus)
                            .onTapGesture {
                                focus = false
                            }
                        HStack {
                            Text("名前")
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: screen.width * 0.11, bottom: 0, trailing: 0))
                                .focused(self.$focus)
                                .onTapGesture {
                                    focus = false
                                }
                            
                            TextField("山田　太郎", text: $nameRecord)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .multilineTextAlignment(.trailing)
                                .focused(self.$focus)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screen.width * 0.11))
                            
                            
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
                            .onTapGesture {
                                focus = false
                            }
                        HStack {
                            Text("体重")
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: screen.width * 0.11, bottom: 0, trailing: 0))
                                .onTapGesture {
                                    focus = false
                                }
                            TextField("0.0", text: $weightRecord)
                            .keyboardType(.decimalPad)
                            .focused(self.$focus)
                            .multilineTextAlignment(.trailing)
                            
                            
                            Text("kg")
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screen.width * 0.11))
                                .onTapGesture {
                                    focus = false
                                }
                        }
                    }
                    //体脂肪率
                    ZStack {
                        // ブロック背景
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                            .frame(width: screen.width * 0.84,
                                   height: screen.height * 0.05)
                            .onTapGesture {
                                focus = false
                            }
                        
                        HStack {
                            Text("体脂肪")
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: screen.width * 0.11, bottom: 0, trailing: 0))
                                .onTapGesture {
                                    focus = false
                                }
                            
                            TextField("0.0", text: $fatRecord)
                            .keyboardType(.decimalPad)
                            .focused(self.$focus)
                            .multilineTextAlignment(.trailing)
                            
                            
                            Text("%")
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: screen.width * 0.11))
                                .onTapGesture {
                                    focus = false
                                }
                        }
                    }
                    
                    //写真
                    ZStack {
                        
                        
                        // ブロック背景
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                            .frame(width: screen.width * 0.84,
                                   height: screen.height * 0.5)
                            .onTapGesture {
                                focus = false
                            }
                        
                        VStack{
                            HStack{
                                Text("写真")
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(width: screen.width * 0.25)
                                    .onTapGesture {
                                        focus = false
                                    }
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
                                                    focus = false
                                                    viewModel.filterImage = false
                                                    viewModel.isShowActionSheet = true
                                                }
                                            
                                        } else {
                                                Button("写真追加"){
                                                    focus = false
                                                    viewModel.filterImage = false
                                                    viewModel.isShowActionSheet = true
                                                }
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                                .frame(width: screen.width * 0.34, height: screen.height * 0.32)
                                            
                                        }
                                        
                                        
                                    }
                                    Text("開始時の体型")
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            focus = false
                                        }
                                }
                                
                                Spacer()
                                
                                VStack{
                                    ZStack{
                                        Text("写真なし")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                            .frame(width: screen.width * 0.34, height: screen.height * 0.32)
                                            .onTapGesture {
                                                focus = false
                                            }
                                    }
                                    
                                    Text("現在の体型")
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            focus = false
                                        }
                                }
                                Spacer()
                            }
                            
                        }
                        .frame(width: screen.width * 0.84,
                               height: screen.height * 0.5)
                        .padding()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        // ブロック背景
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("purple"))
                            .frame(width: screen.width * 0.84,
                                   height: screen.height * 0.05)
                            .onTapGesture {
                                focus = false
                            }
                        HStack {
                            Spacer()
                            if changed {
                                ProgressView()
                            } else {
                                Button("保存") {
                                    focus = false
                                    if !weightRecord.isEmpty && !fatRecord.isEmpty {
                                        if weightRecord.range(of: numText, options: .regularExpression, range: nil, locale: nil) != nil && fatRecord.range(of: numText, options: .regularExpression, range: nil, locale: nil) != nil {
                                            
                                            
                                            print("1")
                                            viewModel.UploadImage(menuViewModel: menuViewModel)
                                            print("2")
                                            changed = true
                                            initialViewModel.registrationUser(menuViewModel: menuViewModel, name: nameRecord, weight: Double(weightRecord)!, fat: Double(fatRecord)!, startImage: viewModel.startImage, viewModel: viewModel)
                                            changed = false
                                            
                                            
                                            print("3")
                                            menuViewModel.datas!.startFirst = true
                                        } else {
                                            showing = AlertItem(alert: Alert(title: Text("不適切な値が入っています")))
                                        }
                                    } else {
                                        
                                    }
                                }
                                .alert(item: $showing) { alert in
                                    alert.alert
                                }
                                .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                }
                
                
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
       
        .actionSheet(isPresented: $viewModel.isShowActionSheet){
            actionSheet
        }
        .sheet(isPresented: $viewModel.isShowImagePickerView){
            ImagePicker(isShown: $viewModel.isShowImagePickerView,
                        image: $viewModel.image,
                        sourceType: viewModel.selectedSourceType)
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(title: Text(viewModel.alertTitle))
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
