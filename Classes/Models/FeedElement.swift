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
    private var height_z: String?
    private var width_z: String?
    
    private var url_l: String?
    private var height_l: String?
    private var width_l: String?
    
    private var url_o: String?
    private var height_o: String?
    private var width_o: String?
    
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
        
        url_o               <- map["url_o"]
        height_o            <- map["height_o"]
        width_o             <- map["width_o"]
    }
    
    lazy var dateTaken: NSDate = {
        [unowned self] in

        let dateFormatter = NSDateFormatter.formatter(withDateFormat: "yyyy-MM-dd HH:mm:ss")
        
        return dateFormatter.dateFromString(self.dateTakenString!)!
        }()
    
    lazy var mediaBundle_z: MediaBundle = {
        let bundle = MediaBundle()
        
        bundle.urlString = self.url_z
        bundle.width = Int(self.width_z!)
        bundle.width = Int(self.height_z!)
        
        return bundle
    }()
    
    lazy var mediaBundle_l: MediaBundle = {
        let bundle = MediaBundle()
        
        bundle.urlString = self.url_l
        bundle.width = Int(self.width_l!)
        bundle.width = Int(self.height_l!)
        
        return bundle
    }()
    
    lazy var mediaBundle_o: MediaBundle = {
        let bundle = MediaBundle()
        
        bundle.urlString = self.url_o
        bundle.width = Int(self.width_o!)
        bundle.width = Int(self.height_o!)
        
        return bundle
    }()
}