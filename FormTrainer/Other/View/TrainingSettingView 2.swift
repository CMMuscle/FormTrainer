//
//  TrainingSettingView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/14.
//

import SwiftUI

struct TrainingSettingView: View {
    
    @ObservedObject var menuViewModel: MenuViewModel
    @StateObject var trainingSettingViewModel = TrainingSettingViewModel()
    @Environment(\.dismiss) var dismiss
    
    let screen = UIScreen.main.bounds
    
    @FocusState var focus: Bool
    
    var body: some View {
        
        ZStack {
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
                .onTapGesture {
                    focus = false
                }
            VStack {
                Spacer()
                ForEach(0..<6) { i in
                    
                    Text("\(menuViewModel.menu[i])")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .onTapGesture {
                            focus = false
                        }
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                        .onTapGesture {
                            focus = false
                        }
                        
                        
                        HStack {
                            TextField("", text: $menuViewModel.stringSetCount[i])
                                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                                .font(.largeTitle)
                                .focused(self.$focus)
                                
                                .keyboardType(.numberPad)
                            Text("セット")
                                .onTapGesture {
                                    focus = false
                                }
                            TextField("", text: $menuViewModel.stringTrainingCount[i])
                                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                                .focused(self.$focus)
                                .font(.largeTitle)
                                .keyboardType(.numberPad)
                            Text((trainingSettingViewModel.plankCheck(name: menuViewModel.menu[i]) ? "秒" : "回"))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))
                                .onTapGesture {
                                    focus = false
                                }
                            
                        }
                    }
                    
                }
                Spacer()
                Button {
                    menuViewModel.saveCount()
                    menuViewModel.flag = false
                    dismiss()
                    print("save")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color("purple"))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                            .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                            .padding()
                        Text("保存")
                            .foregroundColor(.white)
                    }
                }
                .onTapGesture {
                    focus = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            menuViewModel.flag = false
        }

    }
}



