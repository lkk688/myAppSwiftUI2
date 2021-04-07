//
//  UserData.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import Foundation

class UserData: ObservableObject {
    @Published var newsdata: [NewsData] // = NewsData.defaultData
    @Published var username: String
    @Published var vipuser: Bool
    @Published var profile: ProfileData
    
    init(newsdata: [NewsData] = NewsData.defaultData, name: String = "TestUser", vip: Bool = true, profile: ProfileData = ProfileData.mydefault) {
        self.newsdata = newsdata
        self.username = name
        self.vipuser = vip
        self.profile = profile
    }
}

let testUser = UserData(newsdata: NewsData.defaultData, name: "TestUser", vip: true, profile: ProfileData.mydefault)

struct ProfileData {
    var username: String
    var prefersNotifications: Bool
    var seasonalPhoto: Season
    var joinedDate: Date
    
    static let mydefault = Self(username: "CMPE277", prefersNotifications: true, seasonalPhoto: .winter)
    
    init(username: String, prefersNotifications: Bool = true, seasonalPhoto: Season = .winter) {
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.seasonalPhoto = seasonalPhoto
        self.joinedDate = Date()
    }
    
    enum Season: String, CaseIterable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
    }
}
