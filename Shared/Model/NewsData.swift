//
//  NewsData.swift
//  myAppUIKit
//
//  Created by Kaikai Liu on 2/6/21.
//

//import Foundation

import UIKit
import MapKit
import os.log

//CLLocationCoordinate2D is neither Codable nor Hashable. This means we can’t use a Core Location coordinate as key in a dictionary
struct Coordinate: Codable, Hashable {
    let latitude, longitude: Double
//    enum CodingKeys: String, CodingKey {
//            case latitude = "latitude"
//            case longitude = "longitude"
//        }
}

class NewsData: NSObject, Identifiable, NSCoding {
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: PropertyKey.identifier)
        coder.encode(title, forKey: PropertyKey.title)
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(story, forKey: PropertyKey.story)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
        coder.encode(weblink, forKey: PropertyKey.weblink)
        //coder.encode(coordinate, forKey: PropertyKey.coordinate)
        coder.encode(coordinate?.latitude, forKey: "latitude")
        coder.encode(coordinate?.longitude, forKey: "longitude")
    }
    
    //Convenience initializers are secondary, supporting initializers for a class.
    required convenience init?(coder: NSCoder) {
        let identifier = coder.decodeInteger(forKey: PropertyKey.identifier)
        
        // The title is required. If we cannot decode a name string, the initializer should fail.
        guard let title = coder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Data object.", log: OSLog.default, type: .debug)
            return nil
        }
        let name = coder.decodeObject(forKey: PropertyKey.name) as? String
        let story = coder.decodeObject(forKey: PropertyKey.story) as? String
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //Int, there’s no need to downcast the decoded value and there is no optional to unwrap
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        let weblink = coder.decodeObject(forKey: PropertyKey.weblink) as? URL
        
//        let coordinate = coder.decodeObject(forKey: PropertyKey.coordinate) as? Coordinate//CLLocationCoordinate2D
        let latitude = coder.decodeObject(forKey: PropertyKey.latitude) as? Double
        let longitude = coder.decodeObject(forKey: PropertyKey.longitude) as? Double
        var coordinate: Coordinate? = nil
        if let latitude=latitude, let longitude=longitude {
            coordinate = Coordinate(latitude: latitude, longitude: longitude)
        }
        
        // Must call designated initializer.
        self.init(identifier: identifier, title: title, name: name, story: story, photo: photo, rating: rating, weblink: weblink, coordinate: coordinate)
        //As a convenience initializer, this initializer is required to call one of its class’s designated initializers before completing. As the initializer’s arguments, you pass in the values of the constants you created while archiving the saved data.
    }
    
    static func saveMyData(mydata: [NewsData]) {
        do {
            let needsavedata = try NSKeyedArchiver.archivedData(withRootObject: mydata, requiringSecureCoding: false)
            try needsavedata.write(to: ArchiveURL)
        } catch {
            //fatalError("Unable to save data")
            print(error)
            os_log("Failed to save data...", log: OSLog.default, type: .error)
        }
    }
    
    static func loadMyDatafromArchive() -> [NewsData]? {
        do {
            guard let codedData = try? Data(contentsOf: NewsData.ArchiveURL) else { return nil }
            let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [NewsData]
            return loadedData
        } catch {
            os_log("Failed to load data...", log: OSLog.default, type: .error)
        }
        return nil
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("MyModelData")
    
    //MARK: Properties
    var identifier: Int
    var title: String
    var name: String?
    var story: String?
    var photo: UIImage? //String? //UIImage?
    var rating: Int
    var weblink: URL?
    var coordinate: Coordinate? //CLLocationCoordinate2D?
    
    struct PropertyKey {
        static let identifier = "id"
        static let title = "title"
        static let name = "name"
        static let story = "story"
        static let photo = "photo"
        static let rating = "rating"
        static let weblink = "weblink"
        //static let coordinate = "coordinate"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    init?(identifier: Int, title: String, name: String?, story: String?, photo: UIImage?, rating: Int, weblink: URL?, coordinate: Coordinate?) {
        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0  {
//            return nil
//        }
        guard !title.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.identifier = identifier
        self.title = title
        self.name = name
        self.story = story
        self.photo = photo
        self.rating = rating
        self.weblink = weblink
        self.coordinate = coordinate
    }
    
    // MARK: - Support for loading data
    static var defaultData: [NewsData] = {
        //load the data
//        if let savedData = loadMyDatafromArchive() {
//            return savedData
//        }
//        if let localData = loadDataFromPlistNamed("localdata"){
//            return localData
//        }
//        else
//        {
//            return loadDataFromCode()
//        }
//        //return loadDataFromPlistNamed("localdata")
        return loadDataFromCode()
    }()
    
    static func loadDataFromCode() -> [NewsData] {
        guard let news1 = NewsData.init(identifier: 1, title: "testing the news title", name: "me", story: "test the story", photo: UIImage(named: "Image1"), rating: 3, weblink: URL(string: "www.google.com"), coordinate: nil) else {
            fatalError("Unable to instantiate data 1")
        }
        guard let news2 = NewsData.init(identifier: 1, title: "testing the news title testing the news title testing the news title testing the news title", name: "me", story: "test the story2", photo: UIImage(named: "Image2"), rating: 1, weblink: URL(string: "www.google.com"), coordinate: nil) else {
            fatalError("Unable to instantiate data 2")
        }
        guard let news3 = NewsData.init(identifier: 1, title: "testing the news title testing the news title testing the news title testing the news title testing the news title", name: "me", story: "test the story", photo: UIImage(named: "Image3"), rating: 5, weblink: URL(string: "www.google.com"), coordinate: nil) else {
            fatalError("Unable to instantiate data 3")
        }
        var mydata = [NewsData]()
        mydata += [news1, news2, news3]
        return mydata
    }
    
    static func loadDataFromPlistNamed(_ plistName: String) -> [NewsData]? {
      guard
        let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
        let dictArray = NSArray(contentsOfFile: path) as? [[String : AnyObject]]
        else {
          //fatalError("An error occurred while reading \(plistName).plist")
            os_log("Failed to load plist file...", log: OSLog.default, type: .error)
            return nil
        }
        
        var mynewsData: [NewsData] = []
        
        for dict in dictArray {
            guard
              let identifier    = dict["identifier"]    as? Int,
              let name          = dict["name"]          as? String,
              let thumbnailName = dict["thumbnailName"] as? String,
              let title         = dict["title"]         as? String,
              let story         = dict["story"]         as? String,
              let userRating    = dict["userRating"]    as? Int,
              let webLink       = dict["webLink"]       as? String,
              let latitude      = dict["latitude"]      as? Double,
              let longitude     = dict["longitude"]     as? Double
              else {
                fatalError("Error parsing dict \(dict)")
            }
            let webURL = URL(string: webLink)!
            let coordinate = Coordinate(latitude: latitude, longitude: longitude) //CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            guard let onenewsdata = NewsData.init(identifier: identifier, title: title, name: name, story: story, photo: UIImage(named: thumbnailName), rating: userRating, weblink: webURL, coordinate: coordinate) else {
                //fatalError("Error creating news")
                os_log("Failed to create data...", log: OSLog.default, type: .error)
                return nil
                
            }
            mynewsData.append(onenewsdata)
        }
        
        return mynewsData
    }

}
