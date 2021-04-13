//
//  UserData.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import Foundation

//No need to conform to Codable
class UserData: ObservableObject {
    @Published var newsdata: [NewsData] = [] // = NewsData.defaultData
    //@Published var username: String
    //@Published var vipuser: Bool
    @Published var profile: ProfileData
    
    init(newsdata: [NewsData] = NewsData.defaultData, profile: ProfileData = ProfileData.mydefault) {
        self.newsdata = newsdata
        //self.username = name
        //self.vipuser = vip
        self.profile = profile
    }
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var newsfileURL: URL {
        return documentsFolder.appendingPathComponent("newsmodel.data")
    }
    private static var profilefileURL: URL {
        return documentsFolder.appendingPathComponent("profilemodel.data")
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.newsfileURL), let profiledata = try? Data(contentsOf: Self.profilefileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.newsdata = NewsData.defaultData
                    self?.profile = ProfileData.mydefault
                }
                #endif
                return
            }
            guard let decodednewsdata = try? JSONDecoder().decode([NewsData].self, from: data) else {
                fatalError("Can't decode saved news data.")
            }
            guard let decodedprofiledata = try? JSONDecoder().decode(ProfileData.self, from: profiledata) else {
                fatalError("Can't decode saved profile data.")
            }
            
            DispatchQueue.main.async {
                self?.newsdata = decodednewsdata
                self?.profile = decodedprofiledata
            }
        }
    }
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let news = self?.newsdata else { fatalError("Self out of scope") }
            guard let myprofile = self?.profile else { fatalError("Self out of scope") }
            
            guard let newsdata = try? JSONEncoder().encode(news) else { fatalError("Error encoding news data") }
            guard let profiledata = try? JSONEncoder().encode(myprofile) else { fatalError("Error encoding profile data") }
            do {
                let outfile = Self.newsfileURL
                try newsdata.write(to: outfile)
                try profiledata.write(to: Self.profilefileURL)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}

let testUser = UserData(newsdata: NewsData.defaultData, profile: ProfileData.mydefault)

struct ProfileData: Identifiable, Codable {
    var id: UUID //ObjectIdentifier
    var username: String
    var prefersNotifications: Bool
    var seasonalPhoto: Season
    var joinedDate: Date
    var vipuser: Bool
    
    static let mydefault = Self(username: "CMPE277", prefersNotifications: true, seasonalPhoto: .winter)
    
    init(id: UUID = UUID(), username: String, prefersNotifications: Bool = true, seasonalPhoto: Season = .winter, vipuser: Bool = true) {
        self.id = id
        self.username = username
        self.prefersNotifications = prefersNotifications
        self.seasonalPhoto = seasonalPhoto
        self.joinedDate = Date()
        self.vipuser = vipuser
    }
    
    enum Season: String, CaseIterable, Codable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
    }
}
