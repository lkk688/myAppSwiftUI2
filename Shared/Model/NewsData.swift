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

class NewsData: Identifiable, Codable {
    
    //MARK: Properties
    var id: UUID
    var title: String
    var name: String?
    var story: String?
    var photo: String? //UIImage? //String? //UIImage?
    var rating: Int
    var weblink: URL?
    var authorphoto: String?
    var category: Category?
    var coordinate: Coordinate? //CLLocationCoordinate2D?
    var isFeatured: Bool

//
//    static func saveMyData(mydata: [NewsData]) {
//        do {
//            let needsavedata = try NSKeyedArchiver.archivedData(withRootObject: mydata, requiringSecureCoding: false)
//            try needsavedata.write(to: ArchiveURL)
//        } catch {
//            //fatalError("Unable to save data")
//            print(error)
//            os_log("Failed to save data...", log: OSLog.default, type: .error)
//        }
//    }
//
//    static func loadMyDatafromArchive() -> [NewsData]? {
//        do {
//            guard let codedData = try? Data(contentsOf: NewsData.ArchiveURL) else { return nil }
//            let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [NewsData]
//            return loadedData
//        } catch {
//            os_log("Failed to load data...", log: OSLog.default, type: .error)
//        }
//        return nil
//    }
//
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("MyModelData")
    
    
    init?(id: UUID = UUID(), title: String, name: String?, story: String?, photo: String?, rating: Int, weblink: URL?, coordinate: Coordinate?, authorphoto: String? = "Spartan", category: Category? = .general, isFeatured: Bool = false) {
        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0  {
//            return nil
//        }
        self.id = id
        guard !title.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        //self.identifier = identifier
        self.title = title
        self.name = name
        self.story = story
        self.photo = photo
        self.rating = rating
        self.weblink = weblink
        self.coordinate = coordinate
        self.authorphoto = authorphoto
        self.category = category
        self.isFeatured = isFeatured
    }
    
    // MARK: - Support for loading data
    static var defaultData: [NewsData] = {
        //load the data
        if let localData = loadDataFromPlistNamed("localdata"){
            return localData
        }
//        else
//        {
//            return loadDataFromCode()
//        }
//      return loadDataFromPlistNamed("localdata")
        return loadDataFromCode()
    }()
    
    static func loadDataFromCode() -> [NewsData] {
        //UIImage(named: "Image1")
        guard let news1 = NewsData.init(title: "testing the news title", name: "me", story: "test the story", photo: "Image1", rating: 3, weblink: URL(string: "www.google.com"), coordinate: nil) else {
            fatalError("Unable to instantiate data 1")
        }
        guard let news2 = NewsData.init(title: "testing the news title testing the news title testing the news title testing the news title", name: "me", story: "test the story2", photo: "Image2", rating: 1, weblink: URL(string: "www.google.com"), coordinate: nil) else {
            fatalError("Unable to instantiate data 2")
        }
        guard let news3 = NewsData.init(title: "testing the news title testing the news title testing the news title testing the news title testing the news title", name: "me", story: "test the story", photo: "Image3", rating: 5, weblink: URL(string: "www.google.com"), coordinate: nil) else {
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
            
            guard let onenewsdata = NewsData.init(title: title, name: name, story: story, photo: thumbnailName, rating: userRating, weblink: webURL, coordinate: coordinate) else {
                //fatalError("Error creating news")
                os_log("Failed to create data...", log: OSLog.default, type: .error)
                return nil
                
            }
            mynewsData.append(onenewsdata)
        }
        
        return mynewsData
    }

}
