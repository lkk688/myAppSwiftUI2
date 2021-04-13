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
    
    var body: some View {
        VStack{
            //?? UIImage(imageLiteralResourceName: "Spartan")
            Image(uiImage: MyImage.retrieveImage(forKey: news.photo) )
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .edgesIgnoringSafeArea(.top)
                .onTapGesture {
                    withAnimation{
                        zoomed.toggle()
                    }
                }
            Text(news.title)
                .padding(.all)
                .background(Color.red)
                .foregroundColor(Color.white)
                .font(Font.headline.smallCaps())
            
        }.navigationTitle(news.name ?? "No name")
        
        
        
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
