//
//  ImagePicker.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/6/21.
//

import SwiftUI

//struct ImagePicker: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct ImagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePicker()
//    }
//}


import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let configuration: PHPickerConfiguration
    let completion: (_ selectedImage: UIImage) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
            controller.delegate = context.coordinator
            return controller
        }

        func updateUIViewController(_: PHPickerViewController, context _: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: PHPickerViewControllerDelegate {
            let parent: ImagePicker

            init(_ parent: ImagePicker) {
              self.parent = parent
            }

            func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
              for image in results {
                image.itemProvider.loadObject(ofClass: UIImage.self) { selectedImage, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }

                    guard let uiImage = selectedImage as? UIImage else {
                        print("unable to unwrap image as UIImage")
                    return
                    }
                    
                    //let coremlclassification=CoreMLClassification.shared
                    //coremlclassification.updateClassifications(for: uiImage)


                    //print(uiImage)
                    self.parent.completion(uiImage)
                }
              }

              parent.presentationMode.wrappedValue.dismiss()
            }
        }
}
