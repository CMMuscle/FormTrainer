//
//  TrainingSettingViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/14.
//

import Foundation

class TrainingSettingViewModel: ObservableObject {
    
    func stringChange(_ name: Int) -> String{
        return String(name)
    }
    
    func plankCheck(name: String) -> Bool{
        if name == "プランク" || name == "サイドプランク" {
            return true
        }
        return false
    }
}
