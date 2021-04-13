//
//  TabedView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI

struct TabedView: View {
    @EnvironmentObject var currentuser: UserData
    
    @State private var tabSelected = 0
    var body: some View {
        TabView(selection: $tabSelected) {
            NewsList(newsdata: $currentuser.newsdata, saveAction: {currentuser.save()})
                .tabItem {
                    Image(systemName: (tabSelected == 0 ? "newspaper" : "newspaper.fill") )
                    Text("News")
                }.tag(0)
            Profile()
                .tabItem {
                    Image(systemName: (tabSelected == 1 ? "person.crop.circle" : "person.crop.circle.fill") )
                    Text("Profile")
                }.tag(1)
            ImagePickView()
                .tabItem {
                    Image(systemName: (tabSelected == 2 ? "photo" : "photo.fill") )
                    Text("Photos")
                }.tag(2)
        }
    }
}

struct TabedView_Previews: PreviewProvider {
    static var previews: some View {
        TabedView().environmentObject(UserData())
    }
}
