//
//  ContentView.swift
//  Shared
//
//  Created by Kaikai Liu on 3/23/21.
//

import SwiftUI

struct ContentView: View {
    var newsdata: [NewsData] = NewsData.defaultData //[]
    @State private var showingAlert = false
    
    var alert: Alert {
        Alert(title:Text("+ Confirmed"), message: Text("Thank you"), dismissButton: .default(Text("OK")))
    }
    
    var body: some View {
        NavigationView {
            List(newsdata) { news in
                NewsCellView(news: news)
            }.navigationTitle("News")
            .navigationBarItems(trailing: Button(action: {self.showingAlert.toggle()}) {
                Image(systemName: "plus")
            })
            .alert(isPresented: $showingAlert, content: {
                self.alert
            })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(newsdata: NewsData.defaultData)
                .previewDevice("iPhone 12 Pro")
        }
    }
}

struct NewsCellView: View {
    var news: NewsData
    var body: some View {
        NavigationLink(destination: NewsDetailView(news: news)) {
            //Image(systemName: "photo")
            Image(uiImage: news.photo ?? UIImage(imageLiteralResourceName: "Spartan"))
                .resizable()
                .frame(width: 80.0, height: 80.0)
                .cornerRadius(8)
            HStack {
                
                VStack(alignment: .leading) {
                    Text(news.name ?? "No name")
                        .font(.headline)
                        .padding(.leading)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("News name"))
                        .accessibilityValue(Text("\(news.name ?? "No name")"))
                    Text(news.title)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack{
                        Text(String(repeating: "★", count: news.rating))
                            .padding(.leading)
                            .foregroundColor(.yellow)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text("News rating"))
                            .accessibilityValue(Text("\(news.rating)"))
                        Spacer()
                        Label("\(news.rating)", systemImage:"hand.thumbsup.fill")
                        Image(systemName: "link.circle")
                    }
                }
            }
        }
    }
}
