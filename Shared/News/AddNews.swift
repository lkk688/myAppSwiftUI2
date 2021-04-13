//
//  AddNews.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var category: Category
    
    var body: some View {
        Picker(selection: $category, label: Text("category")) {
            ForEach(Category.allCases) { category in
                Text(category.rawValue).tag(category)
            }
        }
    }
}

struct BuildingPicker: View {
    @Binding var building: Building
    
    var body: some View {
        Picker(selection: $building, label: Text("Building")) {
            ForEach(Building.allCases) { building in
                Text(building.rawValue).tag(building)
            }
        }
    }
}

struct AddNews: View {
    @State var addnews = AddNewsData()
    
    @Binding var newsdata: [NewsData]
    
    @Binding var showSheetView: Bool
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter your news information")) {
                    //Text("")
                    TextField("Enter your name", text: $addnews.name)
                    TextField("Enter your news title", text: $addnews.title)
                }
                Section(header: Text("Enter your news")) {
                    //TextEditor is new in SwiftUI2.0
                    TextEditor(text: $addnews.story)
                        .foregroundColor(.secondary)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 200)
                }
                Section(header: Text("Choose options")) {
                    CategoryPicker(category: $addnews.category)
                }
                Section(header: Text("Extras")) {
                    Toggle(isOn: $addnews.urgent) {
                        Text("Urgent")
                    }
                    BuildingPicker(building: $addnews.building)
                    Toggle(isOn: $addnews.includePlacement) {
                        Text("Add Location Placement")
                    }
                    if addnews.includePlacement {
                        NavigationLink(destination: Text("Placement")) {
                            Text("Location Placement")
                        }
                    }
                }
                Section(header: Text("Add your rating")) {
                    Stepper(value: $addnews.rating, in: 1...5) {
                        Text("Rating: \(addnews.rating)")
                    }
                }
            }
            .navigationTitle("Post your news")
            .navigationBarItems(trailing: Button(action: {
                print("Saving new data, Dismissing sheet view...")
                let creatednewdata = NewsData.init(title: addnews.title, name: addnews.name, story: addnews.story, photo: nil, rating: addnews.rating, weblink: nil, coordinate: nil)
                if creatednewdata != nil {
                    newsdata.append(creatednewdata!)
                }
                
                self.showSheetView = false
            }) {
                Text("Save").bold()
            })
        }
    }
}

struct AddNews_Previews: PreviewProvider {
    static var previews: some View {
        AddNews(newsdata: .constant(NewsData.defaultData), showSheetView:.constant(true))
    }
}
