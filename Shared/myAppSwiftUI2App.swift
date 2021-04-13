//
//  myAppSwiftUI2App.swift
//  Shared
//
//  Created by Kaikai Liu on 3/23/21.
//

import SwiftUI

@main
struct myAppSwiftUI2App: App {
    @StateObject private var userdata = UserData()
    var body: some Scene {
        WindowGroup {
            //NewsList()
            TabedView().environmentObject(userdata)
                .onAppear{
                    userdata.load()
                }
            //Profile(currentuser: userdata)
        }
    }
}
