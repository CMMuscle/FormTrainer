//
//  MissionViewModel.swift
//  FormTrainer
//
//  Created by 稗田一亜 on 2023/01/25.
//

import SwiftUI
import UIKit
import BackgroundTasks

class MissonViewModel: ObservableObject {
    
    @Published var dayMissionMenu = ["プランク","バックスクワット","腹筋","バックプランク","スクワット","腕立て"]
    @Published var dayUnit = [String]()
    @Published var dayMenuNum = [Int]()
    @Published var weekMissionMenu = ["プランク","バックスクワット","腹筋","バックプランク","スクワット","腕立て"]
    @Published var weekMenuNum = [Int]()
    
    @Published var dayMenuIndex = 0
    @Published var dayCountIndex = 0
    
    @AppStorage("day") var day = 0
    @AppStorage("first") var firstMission = true
    
    let screen = UIScreen.main.bounds
    
    init() {
        dayMissonSelect()
    }
    
    
}

