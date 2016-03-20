//
//  FeedElement.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import Foundation
import ObjectMapper

class FeedElement: Mappable {
    var title: String?
    var description: String?
    var author: String?
    var authorIdentifier: String?
    var tagsString: String?
    
    private var dateTakenString: String?
    
    private var url_z: String?
    private var height_z: AnyObject?
    private var width_z: AnyObject?
    
    private var url_l: String?
    private var height_l: AnyObject?
    private var width_l: AnyObject?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        title               <- map["title"]
        dateTakenString     <- map["datetaken"]
        description         <- map["description._content"]
        author              <- map["ownername"]
        authorIdentifier    <- map["owner"]
        tagsString          <- map["tags"]
        
        url_z               <- map["url_z"]
        height_z            <- map["height_z"]
        width_z             <- map["width_z"]
        
        url_l               <- map["url_l"]
        height_l            <- map["height_l"]
        width_l             <- map["width_l"]
    }
    
    //MARK: - Lazy Variables
    
    lazy var dateTaken: NSDate = {
        [unowned self] in

        let dateFormatter = NSDateFormatter.formatter(withDateFormat: "yyyy-MM-dd HH:mm:ss")
        
        return dateFormatter.dateFromString(self.dateTakenString!)!
        }()
    
    lazy var mediaBundle_z: MediaBundle = {
        let bundle = MediaBundle()
        
        bundle.urlString = self.url_z
        
        if let width = self.width_z as? String {
            bundle.width = Int(width)
        } else {
            bundle.width = self.width_z as? Int
        }
        
        if let height = self.height_z as? String {
            bundle.height = Int(height)
        } else {
            bundle.height = self.height_z as? Int
        }
        
        return bundle
    }()
    
    lazy var mediaBundle_l: MediaBundle = {
        let bundle = MediaBundle()
        
        bundle.urlString = self.url_l
        
        if let width = self.width_l as? String {
            bundle.width = Int(width)
        } else {
            bundle.width = self.width_l as? Int
        }
        
        if let height = self.height_l as? String {
            bundle.height = Int(height)
        } else {
            bundle.height = self.height_l as? Int
        }
        
        return bundle
    }()
    
    lazy var formattedTagsString: String = {
        var formattedString: String = ""
        
        let tags = self.tagsString!.componentsSeparatedByString(" ")
        
        for tag in tags {
            formattedString += "#\(tag) "
        }
        
        return formattedString
    }()
}