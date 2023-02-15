//
//  TrainingView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/30.
//

import SwiftUI

struct TrainingView: View {
    
    @Environment(\.dismiss) var dismiss
    let screen = UIScreen.main.bounds
    let trainingName: String
    
    @ObservedObject var menuViewModel: MenuViewModel
    @StateObject var trainingViewModel = TrainingViewModel()
    
    @State var showingView = false
    
    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
            
            VStack {
                
                if trainingViewModel.trainingSucess == -1 {
                    // 筋トレフォーム確認
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        Text(trainingName)
                            .font(.title2)
                            .offset(y: -screen.height * 0.1)
                        
                        Image(trainingName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: screen.height * 0.12)
                        
                        
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                    .padding(EdgeInsets(top: screen.height * 0.05, leading: 0, bottom: 0, trailing: 0))
                } else {
                    // 現在の残りトレーニング情報
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                            
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            Text(trainingViewModel.plankCheck(name: trainingName, parts: "のこり"))
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                            
                            HStack {
                                
                                Text("\(trainingViewModel.nowSetCount)")
                                    .font(.title) +
                                Text("セット") +
                                Text("\(Int(trainingViewModel.nowTrainingCount))")
                                    .font(.title) +
                                Text("\(trainingViewModel.plankCheck(name: trainingName, parts: "単位"))")
                                
                            }
                            
                            Spacer()
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.2)
                    .padding()
                }
                
                Spacer()
                
                
                if trainingViewModel.trainingSucess == -1 {
                    
                    // セット数確認
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            Text("セット数")
                                .font(.title2)
                                .padding()
                            
                            Spacer()
                            
                            HStack {
                                Text("\(trainingViewModel.menuCheck(name: trainingName, countMenu: trainingViewModel.trainingMaxCount, setMenu: trainingViewModel.setMaxCount, index: "set"))")
                                    .font(.title) +
                                Text("セット") +
                                Text("\(trainingViewModel.menuCheck(name: trainingName, countMenu: trainingViewModel.trainingMaxCount, setMenu: trainingViewModel.setMaxCount,  index: "training"))")
                                    .font(.title) +
                                Text(trainingViewModel.plankCheck(name: trainingName, parts: "単位"))
                                
                            }
                            
                            Spacer()
                        }
                        
                        
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.2)
                    .padding()
                } else if trainingViewModel.trainingSucess == 0 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("一時停止")
                                .font(.title)
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                    .onTapGesture {
                        trainingViewModel.pauseTraining()
                    }
                } else if trainingViewModel.trainingSucess == 1 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color("purple"))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("再開")
                                .font(.title)
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                    .onTapGesture {
                        trainingViewModel.pauseTraining()
                    }
                } else if trainingViewModel.trainingSucess == 2 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("インターバル")
                                .font(.title)
                            Text("のこり")
                                .font(.title)
                            
                            HStack {
                                Text("\(trainingViewModel.interbalTime)")
                                    .font(.title) +
                                Text("秒")
                            }
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                    
                } else if trainingViewModel.trainingSucess == 3 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color("purple"))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            Spacer()
                            
                                Button {
                                    showingView = true
                                } label: {
                                    Text("グラフ閲覧")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }

                                
                            
                            Spacer()
                        }
                    }
                    .fullScreenCover(isPresented: $showingView, content: {
                        RecordView(menuViewModel: menuViewModel, showingView: $showingView)
                    })
                    .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                }
                
                Spacer()
                
                if trainingViewModel.trainingSucess == -1 {
                    
                    
                    // スタートボタン
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color("purple"))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("START")
                                .font(.title)
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.27)
                    .onTapGesture {
                        if !trainingViewModel.trainingNow {
                            trainingViewModel.initViewModel(viewModel: menuViewModel)
                            trainingViewModel.training()
                        }
                    }
                    .padding()
                } else if trainingViewModel.trainingSucess == 0 {
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("中断する")
                                .font(.title)
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.1)
                } else if trainingViewModel.trainingSucess == 1 || trainingViewModel.trainingSucess == 2{
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color("purple"))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("中断する")
                                .font(.title)
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.1)
                    .onTapGesture {
                        trainingViewModel.stopTraining()
                        dismiss()
                        
                    }
                } else if trainingViewModel.trainingSucess == 3 {
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color("purple"))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Text("メニュー画面に戻る")
                                .font(.title)
                            
                        }
                    }
                    .frame(width: screen.width * 0.84, height: screen.height * 0.1)
                    .onTapGesture {
                        dismiss()
                    }
                }
            }
        }
        .onAppear{
//            trainingViewModel.init(viewModel: menuViewModel)
            
            trainingViewModel.initMenu(countMenu: menuViewModel.trainingMaxCount, setMenu: menuViewModel.setMaxCount, menu: menuViewModel.menu, name: trainingName)
            if trainingName == "バックスクワット" || trainingName == "サイドプランク" {
                trainingViewModel.speeche(text: "左から始めます")
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(
                        action: {
                            dismiss()
                            trainingViewModel.stopTraining()
                        }, label: {
                            Text("＜")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    )
                }
            }
            ToolbarItem(placement: .principal) {
                Text("トレーニング")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Spacer()
            }
            
        }
    }
}

