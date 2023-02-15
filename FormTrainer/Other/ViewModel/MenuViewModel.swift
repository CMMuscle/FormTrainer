//
//  MenuViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/09/26.
//

import SwiftUI
import Combine
import Firebase



class MenuViewModel: ObservableObject {
    @Published var showingModal = false
    let menu = ["プランク","バックスクワット","腹筋","サイドプランク","背筋","腕立て"]
    
    // "プランク","ブルガリアンスクワット","腹筋","サイドプランク","背筋","腕立て"
    @Published var setMaxCount = [2, 5, 1, 3, 7, 3]
    @Published var trainingMaxCount = [20, 10, 1, 10, 10, 10]
    
    @Published var stringSetCount = ["2","5","1","3","7","3"]
    @Published var stringTrainingCount = ["10","10","1","10","10","10"]
    
    private var db = Firestore.firestore()
    
    @Published var datas: MuscleData?
    @Published var menus: [Menus]?
    @Published var days = 10
    
    let screen = UIScreen.main.bounds
    
    // 各itemの幅
    private let ITEM_PADDING: CGFloat = 20
    
    @Published var flag = false
    
    @AppStorage("start") var startImageData : Data = .init(capacity:0)
    @AppStorage("now") var nowImageData : Data = .init(capacity:0)
    
    
    // offset移動アニメーション時間
    private let OFFSET_X_ANIMATION_TIME: Double = 0.2
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    // 無限カルーセル用に加工した配列
    @Published var infinityArray: [String] = []
    // 初期位置は2に設定する
    @Published var currentIndex = 2
    // アニメーションの有無を操作
    @Published private var isOffsetAnimation: Bool = false
    // アニメーション
    @Published var dragAnimation: Animation? = nil
    
    @Published var user: User!
    @Published var weight: Weight!
    @Published var fat: PeopleFat!
    @Published var subMenu = [Menus]()
    @Published var stats = [Stats]()
    
    @Published var firstComing = false
    
    @Published var dayMissionMenu = ["プランク","バックスクワット","腹筋","サイドプランク","背筋","腕立て"]
    @Published var dayUnit = [String]()
    @Published var dayMenuNum = [Int]()
    @Published var weekMissionMenu = ["プランク","バックスクワット","腹筋","サイドプランク","背筋","腕立て"]
    @Published var weekMenuNum = [Int]()
    @Published var weekUnit = [String]()
    
    @Published var dayMenuIndex = 0
    @Published var dayCountIndex = 0
    
    @AppStorage("day") var day = 0
    @AppStorage("first") var firstMission = true
    @AppStorage("go") var firstCount = true
    
    @Published var isChanged = false
    
    @Published var todayCount = [NowCount(id: UUID(), menuName: "プランク", Count: 0),NowCount(id: UUID(), menuName: "バックスクワット", Count: 0),NowCount(id: UUID(), menuName: "腹筋", Count: 0),NowCount(id: UUID(), menuName: "サイドプランク", Count: 0),NowCount(id: UUID(), menuName: "背筋", Count: 0),NowCount(id: UUID(), menuName: "腕立て", Count: 0)]
    
    
    init() {
        print("oifawjwoifjaewoij")
        subscribe()
        
        for i in 0..<menu.count {
            setMaxCount[i] = Int(stringSetCount[i]) ?? 3
            trainingMaxCount[i] = Int(stringTrainingCount[i]) ?? 10
            print("\(stringSetCount[i])  \(stringTrainingCount[i])")
        }
        
        // Navigationbarの色変更
        setupNavigationBar()
        
        // カールセルの個数分の配列を入れる
        infinityArray = createInfinityArray(menu)
    
        $currentIndex
            .receive(on: RunLoop.main)
            .sink { index in
                
                // 2要素未満の場合は、無限スクロールにしないため処理は必要なし
                if self.menu.count < 2 {
                    return
                }
                
                // 無限スクロールを実現させるため、オフセット移動アニメーション後（0.2s後）にcurrentIndexをリセットする
                DispatchQueue.main.asyncAfter(deadline: .now() + self.OFFSET_X_ANIMATION_TIME) {
                    if index <= 1 {
                        self.isOffsetAnimation = false
                        self.currentIndex = 1 + self.menu.count
                    } else if index >= 2 + self.menu.count {
                        self.isOffsetAnimation = false
                        self.currentIndex = 2
                    }
                }
            }
            .store(in: &cancellableSet)
        
        $isOffsetAnimation
            .receive(on: RunLoop.main)
            .map { isAnimation in
                return isAnimation ? .linear(duration: self.OFFSET_X_ANIMATION_TIME) : .none
            }
            .assign(to: \.dragAnimation, on: self)
            .store(in: &cancellableSet)
        
        dayMissonSelect()
        weekMissionSelect()
        
        
        
        
    }
    
    func statusAdd(weight: Double, fat: Double) {
        for (index, country) in datas!.date.week[datas!.date.week.count - 1].user.weight.enumerated() {
            if country.date == today() {
                datas!.date.week[datas!.date.week.count - 1].user.weight[index] = Weight(id: UUID(), weight: weight, date: today())
            }
        }
        for (index, country) in datas!.date.week[datas!.date.week.count - 1].user.peopleFat.enumerated() {
            if country.date == today() {
                datas!.date.week[datas!.date.week.count - 1].user.peopleFat[index] = PeopleFat(id: UUID(), peopleFat: fat, date: today())
            }
        }
    }
    
    func dayReset() {
        let day = Calendar.current.component(.day, from: Date())
        if day != self.day {
            datas!.nowCount = [NowCount(id: UUID(), menuName: "プランク", Count: 0),NowCount(id: UUID(), menuName: "バックスクワット", Count: 0),NowCount(id: UUID(), menuName: "腹筋", Count: 0),NowCount(id: UUID(), menuName: "サイドプランク", Count: 0),NowCount(id: UUID(), menuName: "背筋", Count: 0),NowCount(id: UUID(), menuName: "腕立て", Count: 0)]
            addMovie(datas!)
            todayCount = datas!.nowCount
            self.day = day
        } else {
            todayCount = datas!.nowCount
        }
    }
    
    func subMenuLoad(menu: String) {
        subMenu = datas!.date.week[datas!.date.week.count - 1].menu.filter{ $0.menuName == menu }
        stats = datas!.date.stats.filter{ $0.menu == menu }
        isChanged = true
        print("aaa\(stats)")
    }
    
    func loadData() {
        
        todayCount = datas!.nowCount
        print("aaaaaaaaa\(todayCount)")
    }
    
    func finishRecord(menuName: String) {
        for i in 0...5 {
            if todayCount[i].menuName == menuName {
                
                let index = datas!.date.week[datas!.date.week.count - 1].menu.firstIndex(of: Menus(id: UUID(), menuName: todayCount[i].menuName, count: todayCount[i].Count, date: today()))
                
                subscribe()
                datas!.date.week[datas!.date.week.count - 1].menu[index!] = (Menus(id: UUID(), menuName: todayCount[i].menuName, count: todayCount[i].Count, date: today()))
                datas!.nowCount = todayCount
                addMovie(datas!)
            }
        }
    }
    
    func nowWeeking() -> Int{
        
        let startOfWeek = Calendar(identifier: .japanese).nextDate(after: Date(), matching: .init(weekday: 1), matchingPolicy: .nextTime, direction: .backward)
        let weekDay = Calendar.current.component(.weekday, from: startOfWeek!)
        
        let firstLoginDate = Calendar.current.date(byAdding: .day, value: weekDay, to: Calendar.current.startOfDay(for: datas!.firstDate))
        
        let span = Date().timeIntervalSince(firstLoginDate!)
        
        let weekNum = Int(span/60/60/24)/7
        
        
        return weekNum
    }
    
   
    
    
    func missionCheck() {
        for i in 0..<dayMenuNum.count {
            let index = todayCount.first(where: { $0.menuName == dayMissionMenu[dayMenuNum[i]] })
            if index?.menuName == "プランク" || index?.menuName == "サイドプランク" {
                if index!.Count >= 60 {
                    dayMissionMenu[dayMenuNum[i]] = "☑︎\(index!.menuName)"
                }
            } else {
                if index!.Count >= 10 {
                    dayMissionMenu[dayMenuNum[i]] = "☑︎\(index!.menuName)"
                }
            }
            print("aaaa\(index)")
            
        }
    }
    
    func firstWeek() {
        if Date() > datas!.weekDatas[datas!.weekDatas.count - 1] {
            let data = dateFirstWeek()
            var week = datas!.date.week
            var weights = [Weight]()
            var fats = [PeopleFat]()
            print("aaaa\(data.count)")
            for i in 0...data.count - 1 {
                var menu = [Menus]()
                for j in 0..<data[i].count {
                    menu.append(Menus(id: UUID(), menuName: "プランク", count: 0, date: data[i][j]))
                    menu.append(Menus(id: UUID(), menuName: "バックスクワット", count: 0, date: data[i][j]))
                    menu.append(Menus(id: UUID(), menuName: "腹筋", count: 0, date: data[i][j]))
                    menu.append(Menus(id: UUID(), menuName: "サイドプランク", count: 0, date: data[i][j]))
                    menu.append(Menus(id: UUID(), menuName: "背筋", count: 0, date: data[i][j]))
                    menu.append(Menus(id: UUID(), menuName: "腕立て", count: 0, date: data[i][j]))
                    
                    weights.append(Weight(id: UUID(), weight: 0.0, date: data[i][j]))
                    fats.append(PeopleFat(id: UUID(), peopleFat: 0.0, date: data[i][j]))
                }
                week.append(Week(id: UUID(), user: User(id: UUID(), name: datas!.date.week[0].user.name, pictureData: PictureData(id: UUID(), startDownloadURL: datas!.date.week[0].user.pictureData.startDownloadURL, nowDownloadURL: datas!.date.week[0].user.pictureData.nowDownloadURL), weight: weights, peopleFat: fats), menu: menu))
            }
            print("kairos\(week)")
            
            datas = MuscleData(id: UUID(), date: Dates(id: UUID(), week: week, stats: datas!.date.stats), first: datas!.first, rank: datas!.rank, weekDatas: datas!.weekDatas, firstDate: datas!.firstDate, nowCount: datas!.nowCount)
            
            addMovie(datas!)
            
            datas!.weekDatas.append(Calendar(identifier: .japanese).nextDate(after: Date(), matching: .init(weekday: 7), matchingPolicy: .nextTime, direction: .forward)!)
        }
    }
    
    func dayMissonSelect() {
        let day = Calendar.current.component(.day, from: Date())
        if day != self.day || firstMission {
            
            while dayMenuNum.count < 3 {
                let randomNumber = Int.random(in: 0...5)
                if !dayMenuNum.contains(randomNumber) {
                    if randomNumber == 0 || randomNumber == 3 {
                        dayUnit.append("60秒")
                    } else {
                        dayUnit.append("10回")
                    }
                    dayMenuNum.append(randomNumber)
                }
            }
            
            self.day = day
            UserDefaults.standard.set(dayMissionMenu, forKey: "dayMissionMenu")
            UserDefaults.standard.set(dayMenuNum, forKey: "dayMenuNum")
            UserDefaults.standard.set(dayUnit, forKey: "dayUnit")
        }
        
        dayMissionMenu = UserDefaults.standard.stringArray(forKey: "dayMissionMenu")!
        dayMenuNum = UserDefaults.standard.array(forKey: "dayMenuNum")! as! [Int]
        dayUnit = UserDefaults.standard.stringArray(forKey: "dayUnit")!
    }
    
    func weekMissionSelect() {
        let weekDay = Calendar.current.component(.weekday, from: Date())
        
        if weekDay <= 1 || firstMission {
            while weekMenuNum.count < 3 {
                let randomNumber = Int.random(in: 0...5)
                if !weekMenuNum.contains(randomNumber) {
                    if randomNumber == 0 || randomNumber == 3 {
                        weekUnit.append("360秒")
                    } else {
                        weekUnit.append("60回")
                    }
                    weekMenuNum.append(randomNumber)
                }
            }
            firstMission = false
            UserDefaults.standard.set(weekMissionMenu, forKey: "weekMissionMenu")
            UserDefaults.standard.set(weekMenuNum, forKey: "weekMenuNum")
            UserDefaults.standard.set(weekUnit, forKey: "weekUnit")
        }
        
        weekMissionMenu = UserDefaults.standard.stringArray(forKey: "weekMissionMenu")!
        weekMenuNum = UserDefaults.standard.array(forKey: "weekMenuNum")! as! [Int]
        weekUnit = UserDefaults.standard.stringArray(forKey: "weekUnit")!
    }
    
    
    
    func dateFirstFormater() -> [String] {
        let nowWeek =  Calendar.current.component(.weekday, from: Date())
        print("aaaaaa\(nowWeek)")
        let today = Date()
        var startOfWeek = Calendar(identifier: .japanese).nextDate(after: today, matching: .init(weekday: 1), matchingPolicy: .nextTime, direction: .backward)
        startOfWeek = Calendar.current.date(byAdding: .hour, value: 9, to: startOfWeek!)!
        let weekDay = Calendar.current.component(.weekday, from: startOfWeek!)
        print("aaaaaa\(weekDay)")
        var dates: [String] = []
        for i in 0..<7 {
            
            let selectedDate = Calendar.current.date(byAdding: .day, value: (weekDay - (nowWeek - i)), to: Date())!
            let modifiedDate = Calendar.current.date(byAdding: .hour, value: 0, to: selectedDate)!
            let month = Calendar.current.component(.month, from: modifiedDate)
            let day = Calendar.current.component(.day, from: modifiedDate)
            let date = "\(month)/\(day)"
            dates.append(date)
        }
        print("aaaaaa\(dates)")
        return dates
    }
    
    func rankUp(menu: String) {
        for i in 0...5 {
            if todayCount[i].menuName == menu {
                datas!.rank.userRankCount += todayCount[i].Count
                datas!.date.stats[i].currentData += CGFloat(todayCount[i].Count)
                while(true) {
                    if datas!.rank.userRankCount >= datas!.rank.userRankMaxCount {
                        datas!.rank.userRankCount -= datas!.rank.userRankMaxCount
                        
                        datas!.rank.userRank += 1
                        
                        datas!.rank.userRankMaxCount += datas!.rank.userRankMaxCount
                        
                    }
                    if datas!.date.stats[i].currentData >= datas!.date.stats[i].goal {
                        datas!.date.stats[i].currentData -= datas!.date.stats[i].goal
                        datas!.date.stats[i].rank += 1
                        datas!.date.stats[i].goal += datas!.date.stats[i].goal
                    } else {
                        addMovie(datas!)
                        subscribe()
                        return
                    }
                }
            }
        }
    }
    
    func dateFirstWeek() -> [[String]]{
        var startOfWeek = Calendar(identifier: .japanese).nextDate(after: datas!.weekDatas[datas!.weekDatas.count - 1], matching: .init(weekday: 1), matchingPolicy: .nextTime, direction: .backward)
        startOfWeek = Calendar.current.date(byAdding: .hour, value: 9, to: startOfWeek!)!
        var endOfWeek = Calendar(identifier: .japanese).nextDate(after: startOfWeek!, matching: .init(weekday: 7), matchingPolicy: .nextTime, direction: .forward)
        endOfWeek = Calendar.current.date(byAdding: .hour, value: 9, to: endOfWeek!)!
        let span = Date().timeIntervalSince(endOfWeek!)
        let weekDay = Calendar.current.component(.weekday, from: startOfWeek!)
        let nowWeek =  Calendar.current.component(.weekday, from: Date())
        var dates = [[String]]()
        if Date() > endOfWeek! {
            let weekNum = Int(span/60/60/24)/7
            for i in 0...weekNum {
                var week = [String]()
                for j in 0..<7 {
                    let selectedDate = Calendar.current.date(byAdding: .day, value: ((weekDay - (nowWeek - j)) + (-7 * i)), to: Date())!
                    let modifiedDate = Calendar.current.date(byAdding: .hour, value: 0, to: selectedDate)!
                    let month = Calendar.current.component(.month, from: modifiedDate)
                    let day = Calendar.current.component(.day, from: modifiedDate)
                    let date = "\(month)/\(day)"
                    week.append(date)
                    
                }
                dates.append(week)
            }
            print("kairos\(dates)")
            return dates
        } else {
            return dates
        }
    }
    
    func dayYear(weekCount: Int) -> String{
        var date = datas!.weekDatas[datas!.weekDatas.count - weekCount]
        return String(Calendar.current.component(.year, from: date))
    }
    
    func today() -> String {
        let selectedDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: 0, to: selectedDate)!
        let month = Calendar.current.component(.month, from: modifiedDate)
        let day = Calendar.current.component(.day, from: modifiedDate)
        let date = "\(month)/\(day)"
        
        return date
    }
    
    func subscribe() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return print("ログインできてません")
        }
        print("aegrjoi")
        db.collection("Muscle").document(uid).addSnapshotListener { documentSnapshot, error in
            print("changes received from firebase")
            
            if error != nil {
                print("Error listening to changes", error?.localizedDescription ?? "fireerror")
                
                
            } else {
                print("damedae")
                if let snapshot = documentSnapshot {
                    self.datas = try? snapshot.data(as: MuscleData.self)
                    
                    print("aaa\(self.datas)")
                }
                
            }
        }
        
    }
    
    func addMovie(_ main: MuscleData) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return print("ログインできてません")
        }
        do {
            let _ = try db.collection("Muscle").document(uid).setData(from: main)
            subscribe()
        }
        catch {
            print(error)
        }
    }
    
    // トレーニング設定を保存
    func saveCount() {
        for i in 0..<menu.count {
            setMaxCount[i] = Int(stringSetCount[i]) ?? 3
            trainingMaxCount[i] = Int(stringTrainingCount[i]) ?? 10
        }
    }
    
    // navigationbarの色変更
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("purple"))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // 擬似無限スクロール用の配列を生成
    private func createInfinityArray(_ targetArray: [String]) -> [String] {
        if targetArray.count > 1 {
            var result: [String] = []
            
            // 最後の2要素
            result += targetArray.suffix(2)
            
            // 本来の配列
            result += targetArray
            
            // 最初の2要素
            result += targetArray.prefix(2).map { $0 }
            
            return result
        } else {
            return targetArray
        }
    }
}

// 各種メソッド
extension MenuViewModel{
    
    // itemPadding
    func carouselItemPadding() -> CGFloat {
        return ITEM_PADDING
    }
    
    // カルーセル各要素のWidth
    func carouselItemWidth() -> CGFloat {
        return UIScreen.main.bounds.width * 0.84
    }
    
    func carouselItemHeight() -> CGFloat {
        return UIScreen.main.bounds.height * 0.39
    }
    
    // itemを中央に配置するためにカルーセルのleading paddingを返す
    func carouselLeadingPadding(index: Int, bodyView: GeometryProxy) -> CGFloat {
        return index == 0 ? bodyView.size.width * 0.081 : 0
    }
    
    // カルーセルのOffsetのX値を返す
    func carouselOffsetX(bodyView: GeometryProxy) -> CGFloat {
        return -CGFloat(self.currentIndex) * (UIScreen.main.bounds.width * 0.84 + self.ITEM_PADDING)
    }
    
    // ドラッグ操作
    func onChangedDragGesture() {
        // ドラッグ時にはアニメーション有効
        if self.isOffsetAnimation == false {
            self.isOffsetAnimation = true
        }
    }
    
    // ドラッグ操作によるcurrentIndexの操作
    func updateCurrentIndex(dragGestureValue: _ChangedGesture<GestureStateGesture<DragGesture, CGFloat>>.Value, bodyView: GeometryProxy) {
        var newIndex = currentIndex
        
        // ドラッグ幅からページングを判定
        if abs(dragGestureValue.translation.width) > bodyView.size.width * 0.3 {
            newIndex = dragGestureValue.translation.width > 0 ? self.currentIndex - 1 : self.currentIndex + 1
        }
        
        // 最小ページ、最大ページを超えないようチェック
        if newIndex < 0 {
            newIndex = 0
        } else if newIndex > (self.infinityArray.count - 1) {
            newIndex = self.infinityArray.count - 1
        }
        
        self.isOffsetAnimation = true
        self.currentIndex = newIndex
    }
}


