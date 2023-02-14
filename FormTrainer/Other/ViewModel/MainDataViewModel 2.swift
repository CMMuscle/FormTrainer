//
//  MainDataViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/26.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseCore

class MainDataViewModel: ObservableObject {
    
    var firstYear = 0
    var firstMonth = 0
    var firstDay = 0
    
    private var db = Firestore.firestore()
    
    @Published var datas: MuscleData?
    @Published var menus: [Menus]?
    @Published var days = 19
    private var listenerRegistration: ListenerRegistration?
    
    
}

struct grayGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .background(Color(hue: 0.10, saturation: 0.10, brightness: 0.98).opacity(0.0)
            )
            .padding(.top, 30)
            .padding(20)
            .cornerRadius(20)
            .overlay(
                configuration.label.padding(10),
                alignment: .topLeading
            )
    }
}
