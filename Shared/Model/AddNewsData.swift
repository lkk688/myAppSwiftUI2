//
//  AddNewsData.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import Foundation
import SwiftUI

struct AddNewsData {
    var title: String = ""
    var name: String = ""
    var story: String = ""
    var rating: Int = 0
    
    var urgent: Bool = false
    var includePlacement: Bool = false
    var building: Building = .engineering
    var category: Category = .emergency
    var myPlacement: UnitPoint = UnitPoint(x: 0, y: 0)
}

enum Category: String, CaseIterable, Hashable, Identifiable {
    case emergency = "Emergency"
    case breakingnews = "Breaking News"
    case business = "Business"
    case technology = "Technology"
    case life = "Life"

    var id: Category {self}
}

enum Building: String, CaseIterable, Hashable, Identifiable {
    case engineering = "Engineering Building"
    case studentunion = "Student Union"
    case parking = "Parking Garage"
    case science = "Science Building"

    var id: Building {self}
}
