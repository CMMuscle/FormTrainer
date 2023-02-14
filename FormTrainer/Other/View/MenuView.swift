//
//  MenuView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/09/26.
//

import SwiftUI

import SwiftUI

struct MenuView: View {
    @StateObject var menuViewModel = MenuViewModel()
    @ObservedObject var loginViewModel: LoginViewModel
    @State var message = ""
    let screen = UIScreen.main.bounds
    
    @State var path: [String] = []
    @State var currentTab = 0
    
    @State var nowMenu = ""
    
    var body: some View {
        if menuViewModel.datas == nil {
            InitialView(menuViewModel: menuViewModel)
        } else {
            NavigationStack(path: $path){
                ZStack(alignment: .leading) {
                    
                    // 背景色
                    Color(red: 0.43, green: 0.43, blue: 0.43)
                        .ignoresSafeArea()
                        .gesture(
                            DragGesture()
                            // 画面から指を離した時のアクション
                                .onEnded({ value in
                                    
                                    // 右スワイプ時
                                    if value.translation.width > 10  {
                                        
                                        // 画面遷移を許可
                                        menuViewModel.flag = true
                                        
                                    } else if value.translation.width < -10{
                                        // スワイプ時
                                        menuViewModel.flag = false
                                    }
                                })
                        )
                    
                    VStack{
                        
                        Spacer()
                        
                        VStack{
                            
                            Spacer()
                            
                            HStack {
                                
                                Spacer()
                                
                                ZStack {
                                    
                                    // ブロック背景
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                                        .frame(width: menuViewModel.carouselItemWidth(), height: menuViewModel.carouselItemHeight())
                                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                                    
                                    
                                    TabView(selection: $currentTab) {
                                        trainingItem(menuViewModel: menuViewModel, nowMenu: $nowMenu, path: $path)
                                            .navigationDestination(for: String.self) { string in
                                                TrainingView( trainingName: string, menuViewModel: menuViewModel)
                                            }
                                            .tag(0)
                                        
                                    }
                                    // 画面遷移
                                    
                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    .frame(width: screen.width * 0.84, height: screen.height * 0.3)
                                }
                                
                                Spacer()
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                        
                        
                        
                    }
                    
                    SideMenuView(menuViewModel: menuViewModel, loginViewModel: loginViewModel)
                        .frame(width: screen.width * 0.5, height: screen.height)
                        .offset(x: menuViewModel.flag ? 0 :  -300)
                        .animation(.default, value: menuViewModel.flag)
                        .gesture(
                            DragGesture()
                            // 画面から指を離した時のアクション
                                .onEnded({ value in
                                    // 右スワイプ時
                                    if value.translation.width > 10  {
                                        
                                        // 画面遷移を許可
                                        menuViewModel.flag = true
                                        
                                    } else if value.translation.width < -10{
                                        // スワイプ時
                                        menuViewModel.flag = false
                                    }
                                })
                            
                            
                        )
                }
                // navigationbarの文字
                .navigationBarItems(
                    leading: Text("Form Trainer")
                        .font(.title)
                        .frame(width: 175, alignment: .topLeading),
                    trailing: Text("ブロンズ")
                        .font(.title)
                        .foregroundColor(.black)
                )
            }
            .onAppear {
                menuViewModel.loadData()
                menuViewModel.firstWeek()
                menuViewModel.dayReset()
            }
            .navigationTitle("")
            
            
        }
    }
    
}

struct trainingItem: View {
    
    @ObservedObject var menuViewModel: MenuViewModel
    
    @State private var offset = CGFloat.zero
    @State private var closeOffset = CGFloat.zero
    @State private var openOffset = CGFloat.zero
    
    @Binding var nowMenu: String
    
    let screen = UIScreen.main.bounds
    
    @GestureState private var dragOffset: CGFloat = 0
    @State var isActive = false
    
    @Binding var path: [String]
    
    var body: some View {
        GeometryReader { bodyView in
            
            // 各ブロックの幅を設定
            LazyHStack(spacing: menuViewModel.carouselItemPadding()) {
                
                // menuViewModel初期化時に用意した配列を使う
                ForEach(menuViewModel.infinityArray.indices, id: \.self) { index in
                    VStack {
                        
                        
                        ZStack {
                            
                            // ブロック背景
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.49, green: 0.49, blue: 0.49))
                                .frame(width: menuViewModel.carouselItemWidth(), height: menuViewModel.carouselItemHeight())
                            
                            // 各筋トレの画像
                            Image(menuViewModel.infinityArray[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: menuViewModel.carouselItemWidth(), height: screen.height * 0.15)
                            // 筋トレ名
                            Text(menuViewModel.infinityArray[index])
                                .foregroundColor(.white)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: screen.width * 0.05, bottom: screen.height * 0.25, trailing: 0))
                                .onChange(of: index) { newValue in
                                    print("aaa\(newValue)")
                                }
                            
                        }
                        
                    }
                    .onTapGesture{
                        DispatchQueue.main.async  {
                            
                            // .navigationDestinationにて画面遷移
                            path.append("\(menuViewModel.infinityArray[index])")
                            print("\(nowMenu)")
                            print("a")
                        }
                    }
                    
                }
                
                // 初期値
                .offset(x: dragOffset)
                
                // カルーセルのOffsetのX値を返す
                .offset(x: menuViewModel.carouselOffsetX(bodyView: bodyView))
                
                // スワイプ時のアニメーション
                .animation(menuViewModel.dragAnimation, value: dragOffset)
                .gesture(
                    DragGesture()
                    
                    // 値を更新
                        .updating($dragOffset, body: { (value, state, _) in
                            state = value.translation.width
                        })
                    
                    // 値が更新された時のアクション
                        .onChanged({ value in
                            menuViewModel.onChangedDragGesture()
                        })
                    
                    // 画面から指を離した時のアクション
                        .onEnded({ value in
                            
                            // タッチ時
                            if value.translation.width > -10 && value.translation.width < 10 {
                                
                                // 画面遷移を許可
                                isActive = true
                                
                            } else { // スワイプ時
                                isActive = false
                                
                                // 次のセルへ移動
                                menuViewModel.updateCurrentIndex(dragGestureValue: value, bodyView: bodyView)
                            }
                        })
                )
                
            }
            
        }
    }
}
