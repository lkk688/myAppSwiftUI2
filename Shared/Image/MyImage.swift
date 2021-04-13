//
//  MyImage.swift
//  myAppSwiftUI2
//
//  Created by Kaikai Liu on 4/12/21.
//

import Foundation
import SwiftUI

class MyImage: Codable {
    let imagename: String
    
    static func filePath(forKey key: String?) -> URL? {
        if key == nil {
            return nil
        }else{
            let fileManager = FileManager.default
            guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                    in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
            
            return documentURL.appendingPathComponent(key! + ".png")
        }
    }
    
    static func store(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            if let filePath = filePath(forKey: key) {
                do  {
                    try pngRepresentation.write(to: filePath,
                                                options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    static func retrieveImage(forKey key: String?) -> UIImage {
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        if key == nil {
            return UIImage(imageLiteralResourceName: "Spartan") //default image
        }else{
            return UIImage(imageLiteralResourceName: key!)
        }
        
//        let assetimage = UIImage(imageLiteralResourceName: key!)
//
//        return assetimage//nil
    }
    
}
