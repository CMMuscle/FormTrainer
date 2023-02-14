//
//  FormTrainerApp.swift
//  FormTrainer
//
//  Created by 稗田一亜 on 2023/01/25.
//

import SwiftUI
import Firebase
import BackgroundTasks

@main
struct FormTrainerApp: App {
    
    @StateObject var loginViewModel = LoginViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if loginViewModel.loginAuth {
                MenuView(loginViewModel: loginViewModel)
            } else {
                StartView(loginViewModel: loginViewModel)
            }
//            RecordView(menuViewModel: MenuViewModel())
        }
    
    }
}
