//
//  RecordView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2023/01/11.
//

import SwiftUI
import UIKit
import Photos

struct RecordView: View {
    @State var message = ""
    let screen = UIScreen.main.bounds
    @Environment(\.dismiss) var dismiss
    @Environment(\.dismiss) var trainingDismiss: DismissAction
    @ObservedObject var menuViewModel: MenuViewModel
    @StateObject private var viewModel = FilterContentViewModel()
    @StateObject private var initialViewModel = InitialViewModel()
    
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
    @State var isActionSheet = false
    @State var isImagePicker = false
    var buttons: [ActionSheet.Button] = []
    
    @State var nameRecord = ""
    @State var weightRecord = ""
    @State var fatRecord = ""
    @FocusState var focus: Bool
    
    @Binding var showingView: Bool
    
    var intFormatter: Formatter = NumberFormatter()
    
    @State var showing: AlertItem?
    
    let numText = "[0-9.]"
    
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
                    .padding(EdgeInsets(top: screen.height * 0.035, leading: 0, bottom: 0, trailing: 0))
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
                                            
                                            
                                        } else {
                                            ProgressView()
                                                .frame(width: screen.width * 0.34, height: screen.height * 0.32)
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
                                                Button("写真追加"){
                                                    viewModel.filterImage = true
                                                    viewModel.isShowActionSheet = true
                                                }
                                                .frame(width: screen.width * 0.34, height: screen.height * 0.32)
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                            
                                        }
                                    }
                                    
                                    Text("現在の体型")
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        
                    }
                    .frame(width: screen.width * 0.84,
                           height: screen.height * 0.5)
                    .padding()
                    
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
                            Button("保存") {
                                focus = false
                                if weightRecord != "" || fatRecord != "" {
                                    viewModel.UploadImage(menuViewModel: menuViewModel)
                                    menuViewModel.statusAdd(weight: Double(weightRecord)!, fat: Double(fatRecord)!)
                                    menuViewModel.datas!.startFirst = true
                                    menuViewModel.datas!.nowFirst = true
                                    showingView = false
                                } else if viewModel.nowFilteredImage == nil {
                                    DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 0.1) {
                                        showing = AlertItem(alert: Alert(title: Text("画像を登録してください")))
                                    }
                                } else {
                                    print("aaaaaa")
                                    DispatchQueue.main.asyncAfter ( deadline: DispatchTime.now() + 0.1) {
                                        showing = AlertItem(alert: Alert(title: Text("体重、体脂肪の欄が空欄です")))
                                    }
                                }
                            }
                            .alert(item: $showing) { alert in
                                alert.alert
                            }
                            
                            .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                    
                }
                
                
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
                Text("記録入力")
                    .foregroundColor(.white)
                    .font(.largeTitle)

                Spacer()
            }

        }
        
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .onAppear {
            if menuViewModel.datas!.startFirst {
                if let picture = menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - 1].user.pictureData.startDownloadURL {
                    print("ytfkugilhoj;")
                    viewModel.downloadImageAsync(url: picture) { image in
                        self.viewModel.startFilteredImage = image
                    }
                }
               
            }
           
            
        }
        .actionSheet(isPresented: $viewModel.isShowActionSheet){
            actionSheet
        }
        .sheet(isPresented: $viewModel.isShowImagePickerView){
            ImagePicker(isShown: $viewModel.isShowImagePickerView,
                        image: $viewModel.image,
                        sourceType: viewModel.selectedSourceType)
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

