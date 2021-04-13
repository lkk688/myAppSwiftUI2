//
//  Profile.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI

struct Profile: View {
    //@StateObject var currentuser = UserData()
    
    //@ObservedObject var currentuser: UserData
    //@ObservedObject var currentuser = UserData() //testUser
    
    @EnvironmentObject var currentuser: UserData
    @Environment(\.editMode) var mode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
                    .padding(.horizontal) //SwiftUI builtin
            }
            if self.mode?.wrappedValue == .inactive {
                ProfileSummary(profile: currentuser.profile)
            } else {
                ProfileEditor(currentuser: currentuser)
            }
            //ProfileSummary(profile:currentuser.profile)
            //ProfileEditor(currentuser: currentuser)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        //Profile(currentuser: testUser)
        Profile()
            .environmentObject(UserData())
    }
}

struct ProfileSummary: View {
    var profile: ProfileData
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        List {
            Text(profile.username)
            .bold()
            .font(.title)
            
            Text("Notifications: \(self.profile.prefersNotifications ? "On": "Off" )")
            Text("User name: \(self.profile.username)")
            
            Text("Joined Date: \(self.profile.joinedDate, formatter: Self.dateFormat)")
        }
    }
}
