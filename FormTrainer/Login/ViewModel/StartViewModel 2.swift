//
//  StartViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/08.
//

import SwiftUI

class StartViewModel: ObservableObject {
    
    let screen = UIScreen.main.bounds
    @Published var signUpModal = false
    @Published var loginModal = false
    
    @Published private var currentTabViewIndex = Int(0)
    
    @Published var currentTab = 0
    
    var timer: Timer?

}
