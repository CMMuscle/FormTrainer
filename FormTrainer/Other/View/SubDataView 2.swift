//
//  SubDataView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/30.
//

import SwiftUI
import Charts

struct SubDataView: View {
    @Environment(\.dismiss) var dismiss
    let screen = UIScreen.main.bounds
    @Binding var trainingName: String
    @ObservedObject var menuViewModel: MenuViewModel
    @ObservedObject var mainDataViewModel: MainDataViewModel
    @State var weekCount = 1
    
    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
            
            VStack {
                
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
                .frame(width: screen.width * 0.84, height: screen.height * 0.26)
                .padding(EdgeInsets(top: screen.height * 0.035, leading: 0, bottom: 0, trailing: 0))
                
                // ランク
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: screen.width * 0.84, height: screen.height * 0.11)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        .padding()
                    
                    VStack {
                        Text("ランク \(menuViewModel.stats[0].rank)")
                            .foregroundColor(Color.white)
                        
                        ZStack {
                            HStack {
                                Rectangle()
                                    .fill(Color(red: 0.61, green: 0.60, blue: 0.60))
                                    .frame(width: screen.width * 0.805, height: screen.height * 0.02)
                                    .padding(EdgeInsets(top: 0, leading: screen.width * 0.1, bottom: 0, trailing: 0))
                                
                                Spacer()
                                
                            }
                            HStack {
                                Rectangle()
                                    .fill(Color(red: 0.85, green: 0.85, blue: 0.85))
                                
                                // あとで関数でサイズを調整できるようにする
                                    .frame(width: screen.width * 0.805 * CGFloat((Double(menuViewModel.stats[0].currentData) / Double(menuViewModel.stats[0].goal))) , height: screen.height * 0.02, alignment: .leading)
                                    .padding(EdgeInsets(top: 0, leading: screen.width * 0.1, bottom: 0, trailing: 0))
                                
                                Spacer()
                                
                            }
                            
                            Text("\(Int(menuViewModel.stats[0].currentData))/\(Int(menuViewModel.stats[0].goal))")
                                .foregroundColor(.black)
                            
                        }
                    }
                }
                
                
                // グラフ
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: screen.width * 0.84, height: screen.height * 0.40)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    
                    VStack {
                        
                        SubChartView(menuViewModel: menuViewModel, mainDataViewModel: mainDataViewModel)
                            .frame(width: screen.width * 0.7, height: screen.height * 0.35)
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .frame(width: screen.width * 0.84, height: screen.height * 0.05)
                        .padding()
                    
                    HStack {
                        Button(menuViewModel.datas!.date.week.count == weekCount ? "" : "<") {
                            // +
                            if menuViewModel.datas!.date.week.count != weekCount {
                                weekCount += 1
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                        Spacer()
                        Text("\(menuViewModel.dayYear(weekCount: weekCount))/\(menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - weekCount].menu[0].date)~\(menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - weekCount].menu[menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - weekCount].menu.count - 1].date)")
                        Spacer()
                        Button(weekCount == 1 ? "" : ">") {
                            // -
                            if weekCount != 1 {
                                weekCount -= 1
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))
                    }
                }
            }
            .onAppear {
                
                print("afewijo\(trainingName)")
            }
            //
        }
    }
    
    
}

struct SubChartView: View {
    
    @ObservedObject var menuViewModel: MenuViewModel
    
    @ObservedObject var mainDataViewModel: MainDataViewModel
    
    let screen = UIScreen.main.bounds
    
    
    
    var body: some View {
        
        VStack {
            Chart {
                ForEach(menuViewModel.subMenu) { menu in
                    
                    BarMark(x: .value("day", menu.date),
                            y: .value("workout_In_Min", menu.count)
                    )
                    .foregroundStyle(by: .value("trainingKind", menu.menuName))
                    
                }
                
            }
            .chartPlotStyle { plotContent in
                plotContent
                    .foregroundColor(.white)
                    .background(.gray.opacity(0.4))
                    .border(Color.white, width: 2)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2, 2]))
                        .foregroundStyle(Color.white)
                    
                    AxisValueLabel() { // construct Text here
                        if let intValue = value.as(String.self) {
                            Text("\(intValue)")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [2, 2]))
                        .foregroundStyle(Color.white)
                    AxisValueLabel() { // construct Text here
                        if let intValue = value.as(Int.self) {
                            
                            Text("\(intValue)")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            .groupBoxStyle(grayGroupBoxStyle())
            .frame(width: screen.width * 0.7)
        }
        
    }
}
