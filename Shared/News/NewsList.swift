//
//  ContentView.swift
//  Shared
//
//  Created by Kaikai Liu on 3/23/21.
//

import SwiftUI

struct NewsList: View {
    //var newsdata: [NewsData] = NewsData.defaultData //[]
    @Binding var newsdata: [NewsData]
    
    //@State private var addnewsdata = AddNewsData()
    
    @State private var showingAlert = false
    @State var showSheetView = false
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    
    var alert: Alert {
        Alert(title:Text("+ Confirmed"), message: Text("Thank you"), dismissButton: .default(Text("OK")))
    }
    
    var body: some View {
        NavigationView {
//            List(newsdata) { news in
//                NewsCellView(news: news)
//
//            }
            List{
                ForEach(newsdata) { news in
                    NavigationLink(
                        destination: NewsDetailView(news: binding(for: news)),
                        label: {
                            NewsCellView(news: news)
                        })
                    //NewsCellView(news: news)
                }
            }
            .navigationTitle("News")
//            .navigationBarItems(trailing: Button(action: {self.showingAlert.toggle()}) {
//                Image(systemName: "plus")
//            })
            .toolbar{
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {self.showingAlert.toggle()}, label: {
//                        Image(systemName: "bell.circle.fill")
//                    })
//                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {self.showingAlert.toggle()}, label: {
                        Image(systemName: "bell.circle.fill")
                    })
                    Button(action: {
                        self.showSheetView.toggle()
                    }, label: {
                        Image(systemName: "pencil.and.outline")
                    })
                }
            }
            .alert(isPresented: $showingAlert, content: {
                self.alert
            })
            .sheet(isPresented: $showSheetView, content: {
                //AddNews(showSheetView: self.$showSheetView)
                AddNews(newsdata: $newsdata, showSheetView: self.$showSheetView)
            })
            .onChange(of: scenePhase, perform: { phase in
                if phase == .inactive {
                    saveAction() //external block
                }
            })
            
        }
    }
    
    private func binding(for news: NewsData) -> Binding<NewsData> {
        guard let newsIndex = newsdata.firstIndex(where: {$0.id == news.id}) else {
            fatalError("Cannot find news in array")
        }
        return $newsdata[newsIndex]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            NewsList(newsdata: NewsData.defaultData)
//                .previewDevice("iPhone 12 Pro")
            
            //change to binding
            NewsList(newsdata: .constant(NewsData.defaultData), saveAction: {})
                .previewDevice("iPhone 12 Pro")
        }
    }
}

struct NewsCellView: View {
    
    var news: NewsData
    var body: some View {
//        NavigationLink(destination: NewsDetailView(news: news)) {
//
//        }
        //?? UIImage(imageLiteralResourceName: "Spartan")
        Image(uiImage: MyImage.retrieveImage(forKey: news.photo))
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
