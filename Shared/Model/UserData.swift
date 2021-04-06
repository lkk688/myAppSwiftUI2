//
//  UserData.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import Foundation

final class UserData: ObservableObject {
    @Published var newsdata: [NewsData] = NewsData.defaultData
    @Published var username: String = "TestUser"
    @Published var vipuser: Bool = true
}
