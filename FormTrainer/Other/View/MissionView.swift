//
//  menuView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/29.
//

import SwiftUI
import BackgroundTasks

struct MissionView: View {
    
    @ObservedObject var menuViewModel: MenuViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: menuViewModel.screen.width * 0.84, height: menuViewModel.screen.height * 0.36)
                    
                    VStack {
                        
                        Text("デイリーミッション")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                        
                        ForEach(0..<3){ i in
                            Text("\(menuViewModel.dayMissionMenu[menuViewModel.dayMenuNum[i]])\(menuViewModel.dayUnit[i])を達成する")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: menuViewModel.screen.width * 0.05, bottom: menuViewModel.screen.height * 0.005, trailing: 0))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                    }
                    .frame(width: menuViewModel.screen.width * 0.84, height: menuViewModel.screen.height * 0.36)
                    
                }
                .padding()
                
                ZStack {
                    
                    // ブロック背景
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: menuViewModel.screen.width * 0.84, height: menuViewModel.screen.height * 0.36)
                    
                    VStack {
                        
                        Text("ウィークリーミッション")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                        
                        ForEach(0..<3){ i in
                            Text("\(menuViewModel.weekMissionMenu[menuViewModel.weekMenuNum[i]])\(menuViewModel.weekUnit[i])を達成する")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: menuViewModel.screen.width * 0.05, bottom: menuViewModel.screen.height * 0.005, trailing: 0))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                    }
                    .frame(width: menuViewModel.screen.width * 0.84, height: menuViewModel.screen.height * 0.36)
                }
                .padding()
            }
            .onAppear {
                menuViewModel.missionCheck()
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
                Text("ミッション")
                    .foregroundColor(.white)
                    .font(.largeTitle)

                Spacer()
            }

        }
    }
}
