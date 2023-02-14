//
//  SettingViewModel.swift
//  Muscle
//
//  Created by 稗田一亜 on 2023/01/17.
//

import SwiftUI
import Firebase
import FirebaseAuth

class SettingViewModel: ObservableObject {
    let screen = UIScreen.main.bounds
    
    func sharePost(shareText: String, shareImage: Image, shareUrl: String) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let activityItems = [shareText, shareImage, URL(string: shareUrl)] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popPC = activityVC.popoverPresentationController {
                popPC.sourceView = activityVC.view
                popPC.barButtonItem = .none
                popPC.sourceRect = activityVC.accessibilityFrame
            }
        }
        
        let viewController = window?.rootViewController
        viewController?.present(activityVC, animated: true)
    }
    
}
