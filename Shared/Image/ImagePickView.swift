//
//  ImagePickView.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI
import PhotosUI

struct ImageListItem: Hashable, Equatable, Identifiable {
  var id: Int
  var image: UIImage
}

struct ImagePickView: View {
    let urls = ["https://www.sjsu.edu/_images/sjsu-homepage-hero/040121_Homepage-ASD-2021_Top_IMG_04.jpg","https://blogs.sjsu.edu/newsroom/files/2015/09/Schmitz_GeneralCampus_7631_1_02-rprer4.jpg","https://blogs.sjsu.edu/newsroom/files/2021/02/strategic-plan-jduarte-031319-19.jpg"]
    
    @State var images: [ImageListItem] = [
        ImageListItem(id: 1, image: UIImage(named: "Image1")!),
        ImageListItem(id: 2, image: UIImage(named: "Image2")!),
        ImageListItem(id: 3, image: UIImage(named: "Image3")!),
      ]
    @State var showPhotoLibrary = false
    var pickerConfiguration: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 10
        return config
      }
    
    var body: some View {
        NavigationView {
              VStack {
                HStack {
                  Button(action: {
                    showPhotoLibrary = true
                  }) {
                    Text("Add photos")
                  }
                  Spacer()
                }.sheet(isPresented: $showPhotoLibrary) {
                  ImagePicker(configuration: pickerConfiguration) { selectedImage in
                    images.append(ImageListItem(id: images.count + 1, image: selectedImage))
                  }
                }

                Collection(data: images, cols: 3, spacing: 2) { data, _ in
                  Image(uiImage: data.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                }
                
                //Get remote image
                VStack{
                    
//                    RemoteImageView(url: URL(string: "https://www.sjsu.edu/_images/sjsu-homepage-hero/040121_Homepage-ASD-2021_Top_IMG_04.jpg")!)
                    
                    ScrollView { //
                        ForEach(urls, id: \.self) {url in
                            RemoteImageView(url: URL(string: url)!)
                        }
                    }
                }
                
                Spacer()
                
              }.navigationBarTitle("Photo", displayMode: .inline).padding()
            }
          }
}

struct ImagePickView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickView()
    }
}
