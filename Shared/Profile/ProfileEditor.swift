//
//  ProfileEditor.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI

struct ProfileEditor: View {
    
    @ObservedObject var currentuser: UserData
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: currentuser.profile.joinedDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: currentuser.profile.joinedDate)!
        return min...max
    }
    
    var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $currentuser.profile.username)
            }
            
            Toggle(isOn: $currentuser.profile.prefersNotifications) {
                Text("Enable Notifications")
            }
            
            Text("Notification Status: \(currentuser.profile.prefersNotifications ? "On":"Off")")
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Seasonal Photo").bold()
                
                Picker("Seasonal Photo", selection: $currentuser.profile.seasonalPhoto) {
                    ForEach(ProfileData.Season.allCases, id: \.self) { season in
                        Text(season.rawValue).tag(season)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Date").bold()
                DatePicker(
                    "Date",
                    selection: $currentuser.profile.joinedDate,
                    in: dateRange,
                    displayedComponents: .date)
            }
            .padding(.top)
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        //ProfileEditor(profile: .constant(.mydefault))
        ProfileEditor(currentuser: testUser)
    }
}
