//
//  TestRemoteImageView.swift
//  myAppSwiftUI2 (iOS)
//
//  Created by Kaikai Liu on 4/18/21.
//

import SwiftUI

struct RemoteImageView: View {
    @StateObject var remoteimage = AsyncRemoteImage()
    
    private var url: URL
    
    init(url: URL){
        self.url = url
    }
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            if remoteimage.image != nil {
                withAnimation(){
                    Image(uiImage: remoteimage.image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                }
            } else {
                //placeholder
                //Image(uiImage: UIImage(imageLiteralResourceName: "Spartan"))
                ActivityIndicator(shouldAnimate: .constant(true))
            }
        }
        .onAppear{
            self.remoteimage.load(url: self.url)
        }
        .onDisappear{
            self.remoteimage.cancel()
        }
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static let url = URL(string: "https://www.sjsu.edu/_images/sjsu-homepage-hero/040121_Homepage-ASD-2021_Top_IMG_04.jpg")!
    static var previews: some View {
        RemoteImageView(url: url)
    }
}
