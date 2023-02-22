//
//  MainDataView.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/11/28.
//

import SwiftUI
import Charts

struct MainDataView: View {
    
    // 横に配置するブロックの個数
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    let screen = UIScreen.main.bounds
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var menuViewModel: MenuViewModel
    
    @StateObject var mainDataViewModel = MainDataViewModel()
    
    @State var isChanged = false
    
    @State var trainingMenu = ""
    
    @State var weekCount = 1
    
    // グラフ切り替え
    let training =  ["メニュー","体重","体脂肪"]
    @State var currentTab = 0
    @State var color = ["バックスクワット": Color.yellow,"プランク": .white, "腹筋": Color.red,   "サイドプランク": Color.orange, "背筋": Color.blue,"腕立て": Color.green]
    
    var body: some View {
        ZStack {
            
            // 背景色
            Color(red: 0.43, green: 0.43, blue: 0.43)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    // ランク
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .frame(width: screen.width * 0.84, height: screen.height * 0.11)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                            .padding()
                        
                        VStack {
                            Text("ランク \(menuViewModel.datas!.rank.userRank)")
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
                                        .frame(width: screen.width * 0.805 * CGFloat((Double(menuViewModel.datas!.rank.userRankCount) / Double(menuViewModel.datas!.rank.userRankMaxCount))) , height: screen.height * 0.02, alignment: .leading)
                                        .padding(EdgeInsets(top: 0, leading: screen.width * 0.1, bottom: 0, trailing: 0))
                                    
                                    Spacer()
                                    
                                }
                                
                                Text("\(menuViewModel.datas!.rank.userRankCount)/\(menuViewModel.datas!.rank.userRankMaxCount)")
                                    .foregroundColor(.black)
                                
                            }
                        }
                    }
                    .padding(EdgeInsets(top: screen.height * 0.035, leading: 0, bottom: 0, trailing: 0))
                    
                    // グラフ
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .frame(width: screen.width * 0.84, height: screen.height * 0.5)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                        
                        VStack {
                            
                            Spacer()
                            Picker(selection: $currentTab, label: Text("フルーツを選択")) {
                                ForEach(0..<training.count, id: \.self){ num in
                                    Text(self.training[num])
                                }
                            }
                            
                            .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
                            .frame(width: screen.width * 0.8)
                            
                            TabView(selection: $currentTab) {
                                
                                ChartView(menuViewModel: menuViewModel, mainDataViewModel: mainDataViewModel, currentTab: 0, weekCount: $weekCount)
                                    .frame(width: screen.width * 0.7, height: screen.height * 0.4)
                                
                                    .tag(0)
                                
                                ChartView(menuViewModel: menuViewModel, mainDataViewModel: mainDataViewModel, currentTab: 1, weekCount: $weekCount)
                                    .frame(width: screen.width * 0.7, height: screen.height * 0.4)
                                    .tag(1)
                                ChartView(menuViewModel: menuViewModel, mainDataViewModel: mainDataViewModel, currentTab: 2, weekCount: $weekCount)
                                    .frame(width: screen.width * 0.7, height: screen.height * 0.4)
                                    .tag(2)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                            
                        }
                        
                    }
                    .frame(width: screen.width * 0.7)
                    
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
                            .foregroundColor(.white)
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
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))
                        }
                    }
                    
                    // 筋トレごとの記録
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach((menuViewModel.datas?.date.stats)!) {stat in
                            VStack(spacing: 22) {
                                HStack {
                                    Text(stat.menu)
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer(minLength: 0)
                                    
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(Color(red: 0.50, green: 0.50, blue: 0.50))
                                        .frame(width: screen.width * 0.42, height: screen.height * 0.18)
                                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                                    
                                    Circle()
                                        .trim(from: 0, to: 1)
                                        .stroke(Color(stat.color).opacity(0.05), lineWidth: 10)
                                        .frame(width: screen.width * 0.29, height: screen.height * 0.13)
                                    
                                    Circle()
                                        .trim(from: 0, to: (stat.currentData / stat.goal))
                                        .stroke(Color(stat.color)
                                                , style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                        .frame(width: screen.width * 0.29, height: screen.height * 0.13)
                                        .rotationEffect(.init(degrees: -90))
                                    
                                    VStack {
                                        Text(String(stat.rank))
                                            .padding(2)
                                        Text(getPercent(current: stat.currentData, Goal: stat.goal))
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                    }
                                }
                                .onTapGesture {
                                    trainingMenu = stat.menu
                                    menuViewModel.subMenuLoad(menu: trainingMenu)
                                    print("\(trainingMenu)afewijo")
                                    isChanged = true
                                    
                                }
                                .sheet(isPresented: $isChanged, content: {
                                    SubDataView(trainingName: $trainingMenu, menuViewModel: menuViewModel, mainDataViewModel: mainDataViewModel)
                                })
                                
                            }
                            
                        }
                    }
                    .padding()
                }
                
            }
        }
        
        // ナビゲーションリンクの遷移先のバーを隠す
        .navigationBarBackButtonHidden(true)
//         ナビゲーションバーを編集する
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
                Text("統計")
                    .foregroundColor(.white)
                    .font(.largeTitle)

                Spacer()
            }
        }
    }
    
    func getPercent(current : CGFloat, Goal : CGFloat)->String {
        
        let per = (current / Goal) * 100
        
        return String(format: "%.1f", per)
    }
}

private struct ViewConstants {
    static let color1 = Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
    static let minYScale = 150
    static let maxYScale = 240
    static let chartWidth: CGFloat = 350
    static let chartHeight: CGFloat = 400
    static let dataPointWidth: CGFloat = 30
    static let barWidth: MarkDimension = 22
}

struct ChartView: View {
    
    @ObservedObject var menuViewModel: MenuViewModel
    
    @ObservedObject var mainDataViewModel: MainDataViewModel
    
    let screen = UIScreen.main.bounds
    
    @State var currentTab: Int
    
    @Binding var weekCount: Int
    
    
    var body: some View {
        if currentTab == 0 {
            VStack {
                Chart {
                    ForEach(menuViewModel.datas!.date.week[menuViewModel.datas!.date.week.count - weekCount].menu) { menu in
                        
                        BarMark(x: .value("day", menu.date),
                                y: .value("workout_In_Min", menu.count)
                        )
                        .foregroundStyle(by: .value("trainingKind", menu.menuName))
                        
                    }
                    
                }
                .chartForegroundStyleScale ([
                    "プランク": .red, "バックスクワット": .yellow, "腹筋": .white, "サイドプランク": .blue, "背筋": .green, "腕立て": .orange
                        ])
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
        } else if currentTab == 1 {
            VStack {
                Chart {
                    ForEach((menuViewModel.datas?.date.week[menuViewModel.datas!.date.week.count - weekCount].user.weight)!) { menu in
                        
                        LineMark(x: .value("day", menu.date),
                                y: .value("workout_In_Min", menu.weight)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .interpolationMethod(.linear)
                    }
                    
                }
                .chartPlotStyle { plotContent in
                    plotContent
                        .foregroundColor(.white)
                        .background(.gray.opacity(0.4))
                        .border(Color.white, width: 2)
                }
                .chartForegroundStyleScale ([
                    "プランク": .red, "バックスクワット": .yellow, "腹筋": .white, "サイドプランク": .blue, "背筋": .green, "腕立て": .orange
                        ])
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
        } else {
            VStack {
                Chart {
                    ForEach((menuViewModel.datas?.date.week[menuViewModel.datas!.date.week.count - weekCount].user.peopleFat)!) { weight in
                        
                        LineMark(x: .value("day", weight.date),
                                y: .value("workout_In_Min", weight.peopleFat)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .interpolationMethod(.linear)
                        
                    }
                    
                }
                .chartPlotStyle { plotContent in
                    plotContent
                        .foregroundColor(.white)
                        .background(.gray.opacity(0.4))
                        .border(Color.white, width: 2)
                }
                .chartForegroundStyleScale ([
                    "プランク": .red, "バックスクワット": .yellow, "腹筋": .white, "サイドプランク": .blue, "背筋": .green, "腕立て": .orange
                        ])
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
}






extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: self)
    }
    
    func isFirstOfMonth() -> Bool {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day == 1
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: self)
    }
    
    func today() -> Bool {
        let components = Calendar.current.dateComponents([.day], from: self)
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        return components.day == calendar.component(.day, from: date)
    }
    
    func todays() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let day = calendar.component(.day, from: date)
        if day < 10 {
            return "0" + String(day)
        } else {
            return String(day)
        }
    }
    
    
}
