//
//  MuscleData.swift
//  Muscle
//
//  Created by 稗田一亜 on 2022/12/26.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

struct MuscleData: Codable, Identifiable {
    var id: UUID
    var date: Dates
    var first: Bool
    var rank: Rank
    var weekDatas: [Date]
    var firstDate: Date
    var nowCount: [NowCount]
    
    
}

extension Menus: Equatable {
    public static func ==(lhs:Menus, rhs:Menus) -> Bool {
        return lhs.menuName == rhs.menuName && lhs.date == rhs.date
    }
}

struct NowCount: Codable, Identifiable {
    var id: UUID
    var menuName: String
    var Count: Int
}

struct Dates: Codable, Identifiable {
    var id: UUID
    var week: [Week]
    var stats: [Stats]
}

struct Week: Codable, Identifiable {
    var id: UUID
    var user: User
    var menu: [Menus]
}

// サンプルデータ
struct Daily:Codable, Identifiable {
    var id: UUID
    var day: String
    var workout_In_Min : Int
    var trainingKind: String
}

struct PictureData: Codable, Identifiable {
    var id: UUID
    var startDownloadURL: URL?
    var nowDownloadURL: URL?
}

struct Menus: Codable, Identifiable {
    var id: UUID
    var menuName: String
    var count: Int
    var date: String
}

struct User: Codable, Identifiable {
    var id: UUID
    var name: String
    var pictureData: PictureData
    var weight: [Weight]
    var peopleFat: [PeopleFat]
}

struct Stats: Codable, Identifiable {
    var id: UUID
    var menu: String
    var currentData: CGFloat
    var goal: CGFloat
    var color: String
    var rank: Int
}

struct Weight: Codable, Identifiable {
    var id: UUID
    var weight: Double
    var date: String
}

struct Rank: Codable, Identifiable {
    var id: UUID
    var userRank: Int
    var userRankCount: Int
    var userRankMaxCount: Int
}

struct PeopleFat: Codable, Identifiable {
    var id: UUID
    var peopleFat: Double
    var date: String
}
