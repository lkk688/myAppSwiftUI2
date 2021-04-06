//
//  AddNews.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI

struct AddNews: View {
    @Binding var showSheetView: Bool
    var body: some View {
        NavigationView {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Done").bold()
            })
        }
    }
}

struct AddNews_Previews: PreviewProvider {
    static var previews: some View {
        AddNews(showSheetView: .constant(true))
    }
}
