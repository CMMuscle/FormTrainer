//
//  InitialViewModel.swift
//  FormTrainer
//
//  Created by 稗田一亜 on 2023/02/03.
//

import Foundation
import Firebase
import SwiftUI

class InitialViewModel: ObservableObject {
    
    @Published var showing = AlertItem(alert: Alert(title: Text("")))
    
    func registrationUser(menuViewModel: MenuViewModel, name: String?, weight: Double?, fat: Double?, startImage: URL?, viewModel: FilterContentViewModel) {
        
        
        
        let data = menuViewModel.dateFirstFormater()
        var menu = [Menus]()
        var stats = [Stats]()
        var weights = [Weight]()
        var fats = [PeopleFat]()
        
        for i in 0..<data.count {
            menu.append(Menus(id: UUID(), menuName: "プランク", count: 0, date: data[i]))
            menu.append(Menus(id: UUID(), menuName: "バックスクワット", count: 0, date: data[i]))
            menu.append(Menus(id: UUID(), menuName: "腹筋", count: 0, date: data[i]))
            menu.append(Menus(id: UUID(), menuName: "サイドプランク", count: 0, date: data[i]))
            menu.append(Menus(id: UUID(), menuName: "背筋", count: 0, date: data[i]))
            menu.append(Menus(id: UUID(), menuName: "腕立て", count: 0, date: data[i]))
            
            weights.append(Weight(id: UUID(), weight: 0.0, date: data[i]))
            fats.append(PeopleFat(id: UUID(), peopleFat: 0.0, date: data[i]))
        }
        
        var calendar = Calendar(identifier: .gregorian)
        
        calendar.locale = Locale(identifier: "ja_JP")
        
        let weekday = calendar.component(.weekday, from: Date())
        weights[weekday - 1] = Weight(id: UUID(), weight: weight!, date: data[weekday - 1])
        fats[weekday - 1] = PeopleFat(id: UUID(), peopleFat: fat!, date: data[weekday - 1])
        
        stats.append(Stats(id: UUID(), menu: "プランク", currentData: 0.0, goal: 2, color: "red",  rank: 1))
        stats.append(Stats(id: UUID(), menu: "バックスクワット", currentData: 0.0, goal: 2, color: "yellow",  rank: 1))
        stats.append(Stats(id: UUID(), menu: "腹筋", currentData: 0.0, goal: 2, color: "white",  rank: 1))
        stats.append(Stats(id: UUID(), menu: "サイドプランク", currentData: 0.0, goal: 2, color: "blue",  rank: 1))
        stats.append(Stats(id: UUID(), menu: "背筋", currentData: 0.0, goal: 2, color: "green",  rank: 1))
        stats.append(Stats(id: UUID(), menu: "腕立て", currentData: 0.0, goal: 2, color: "orange",  rank: 1))
        
        menuViewModel.datas = MuscleData(id: UUID(), date: Dates(id: UUID(), week: [Week(id: UUID(), user: User(id: UUID(), name: name!, pictureData: PictureData(id: UUID(), startDownloadURL: startImage, nowDownloadURL: nil), weight: weights, peopleFat: fats), menu: menu)], stats: stats), startFirst: true ,nowFirst: false, rank: Rank(id: UUID(), userRank: 1, userRankCount: 0, userRankMaxCount: 2), weekDatas: [Calendar(identifier: .japanese).nextDate(after: Date(), matching: .init(weekday: 7), matchingPolicy: .nextTime, direction: .forward)!], firstDate: Date(), nowCount: [NowCount(id: UUID(), menuName: "プランク", Count: 0),NowCount(id: UUID(), menuName: "バックスクワット", Count: 0),NowCount(id: UUID(), menuName: "腹筋", Count: 0),NowCount(id: UUID(), menuName: "サイドプランク", Count: 0),NowCount(id: UUID(), menuName: "背筋", Count: 0),NowCount(id: UUID(), menuName: "腕立て", Count: 0)])
        
        menuViewModel.add(menuViewModel.datas!)
        menuViewModel.subscribe()
        viewModel.UploadImage(menuViewModel: menuViewModel)
        
    }
}
//"プランク","バックスクワット","腹筋","サイドプランク","背筋","腕立て"
