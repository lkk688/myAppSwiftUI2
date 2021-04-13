//
//  NewsDetailView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 3/23/21.
//

import SwiftUI

struct NewsDetailView: View {
    //var news: NewsData
    @Binding var news: NewsData
    @State private var zoomed = false
    
    @StateObject var mapmodel = MapModel()//(coordinate: news.coordinate)
    @State private var ismapviewPresented = false
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack{
            //?? UIImage(imageLiteralResourceName: "Spartan")
            Image(uiImage: MyImage.retrieveImage(forKey: news.photo) )
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                //.edgesIgnoringSafeArea(.top)
                .onTapGesture {
                    withAnimation{
                        zoomed.toggle()
                    }
                }
//            Text(news.title)
//                .padding(.all)
//                .background(Color.red)
//                .foregroundColor(Color.white)
//                .font(Font.headline.smallCaps())
            CircleImage(image: Image(uiImage: MyImage.retrieveImage(forKey: news.authorphoto)))
                .frame(width: 90, height: 90)
                .offset(x: -130, y: -70)
                .padding(.bottom, -150)
            DetailItemView(news: news).padding()
            Text(news.story ?? "").padding()
            HStack(spacing: 20.0){
//                Text("Featured: \(news.isFeatured.description)")
//                Button(action: {
//                    news.isFeatured.toggle()
//                }) {
//                    if news.isFeatured {
//                        HStack{
//                            Image(systemName: "hand.thumbsup.fill")
//                                .foregroundColor(Color.blue)
//                            Text("Remove like")
//                        }
//                    } else {
//                        HStack{
//                            Image(systemName: "hand.thumbsup")
//                                .foregroundColor(Color.gray)
//                            Text("Like it")
//                        }
//                    }
//                }
                
                Button(action: {
                    mapmodel.update(name: news.name, coordinate: news.coordinate)
                    ismapviewPresented = true
                }, label: {
                    HStack{
                        Text("Show map")
                        Image(systemName: "map")
                    }
                }).disabled(news.weblink == nil)
                Button("Open link") {
                    openURL(news.weblink!)
                    //Image(systemName: "network")
                }.disabled(news.weblink == nil)
            }
            
            Spacer()
        }
        .navigationBarTitle(news.name ?? "No name", displayMode: .inline)
        .fullScreenCover(isPresented: $ismapviewPresented, content: {
            NavigationView{
                MapView(mapmodel: mapmodel)
                    .navigationTitle(news.name ?? "")
                    .navigationBarItems(trailing: Button("Done"){
                        ismapviewPresented = false
                    })
            }
        })
        
        
        
    }
}

struct CircleImage: View {
    var image: Image

    var body: some View {
        //Image(uiImage: MyImage.retrieveImage(forKey: news.photo))
        image
            .resizable()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .scaledToFit()
    }
}

struct DetailItemView: View {
    var news: NewsData
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(news.name ?? "")
                    .font(.title)
                
//                Button(action: {
//                    self.userData.dataitems[self.itemIndex]
//                        .isFavorite.toggle()
//                }) {
//                    if self.userData.dataitems[self.itemIndex].isFavorite {
//                        Image(systemName: "star.fill")
//                            .foregroundColor(Color.yellow)
//                    } else {
//                        Image(systemName: "star")
//                            .foregroundColor(Color.gray)
//                    }
//                }
            }
            
            HStack(alignment: .top) {
                Text(news.name ?? "")
                    .font(.subheadline)
                Spacer()
                Text(String(repeating: "★", count: news.rating))
                    .padding(.leading)
                    .foregroundColor(.yellow)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("News rating"))
                    .accessibilityValue(Text("\(news.rating)"))
            }
        }
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
//            NewsDetailView(news: NewsData.defaultData[1])
            NewsDetailView(news: .constant(NewsData.defaultData[1]))
        }
    }
}
