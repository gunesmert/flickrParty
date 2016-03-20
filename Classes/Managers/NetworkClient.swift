//
//  NetworkClient.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import Alamofire
import ObjectMapper

private let APIBaseURL = "https://api.flickr.com/services/rest/"

private let APIKey = "74b3c29fd1071151559fc39aba3bb04c"

let FLCNetworkClientErrorDomain = "FLCNetworkClientErrorDomain"

enum ErrorCode: Int {
    case InvalidParameters = 600
    case InvalidJSON = 601
}

class NetworkClient {
    class var sharedClient: NetworkClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkClient? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkClient()
        }
        
        return Static.instance!
    }
    
    
    /**
     Fetches feed elements with the given tags array.
     
     - returns: Fetched page number, number of total pages, feed elements and error.
     */
    func getFeedElements(withPageNumber pageNumber:NSNumber, withTags tags: [String], completion: (NSNumber?, NSNumber?, [FeedElement]?, NSError?) -> Void) {
        var parameters: [String: AnyObject] = [:]
        parameters["page"] = pageNumber
        parameters["per_page"] = 10
        
        var tagsString = ""
        
        for tag in tags {
            tagsString += tag + ","
        }
        
        parameters["tags"] = tagsString.substringToIndex(tagsString.endIndex.predecessor())
        
        parameters["format"] = "json"
        parameters["method"] = "flickr.photos.search"
        parameters["api_key"] = APIKey
        parameters["extras"] = "description,tags,owner_name,date_taken,url_sq,url_n,url_z,url_c,url_l,url_o"
        
        var headers: Dictionary<String, String> = [:]
        
        headers["Content-Type"] = "application/json"
        
        Alamofire.request(Method.GET,
            APIBaseURL,
            parameters: parameters,
            encoding: ParameterEncoding.URL,
            headers: headers)
            .response { request, response, data, error in
                if error == nil {
                    guard let localData = data else {
                        let inlineError = NSError(domain: FLCNetworkClientErrorDomain, code: ErrorCode.InvalidParameters.rawValue, userInfo: nil)
                        
                        completion(nil, nil, nil, inlineError)
                        
                        return
                    }
                    
                    guard let trimmedData = self.trim(Data: localData) else {
                        let inlineError = NSError(domain: FLCNetworkClientErrorDomain, code: ErrorCode.InvalidParameters.rawValue, userInfo: nil)
                        
                        completion(nil, nil, nil, inlineError)
                        
                        return
                    }
                    
                    guard let jsonDict = trimmedData.jsonObjectRepresentation() as! [String: AnyObject]? else {
                        let inlineError = NSError(domain: FLCNetworkClientErrorDomain, code: ErrorCode.InvalidJSON.rawValue, userInfo: nil)
                        
                        completion(nil, nil, nil, inlineError)
                        
                        return;
                    }
                    
                    let pageNumber = (jsonDict as AnyObject).valueForKeyPath("photos.page") as! NSNumber
                    
                    let numberOfPages = (jsonDict as AnyObject).valueForKeyPath("photos.pages") as! NSNumber
                    
                    let elements: [FeedElement]? = Mapper<FeedElement>().mapArray((jsonDict as AnyObject).valueForKeyPath("photos.photo"))
                    
                    completion(pageNumber, numberOfPages, elements, nil)
                } else {
                    completion(nil, nil, nil, error)
                }
        }
    }
    
    func trim(Data data: NSData) -> NSData? {
        var dataString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        
        dataString = dataString.substringFromIndex((dataString.rangeOfString("(")?.endIndex)!)
        dataString = dataString.substringToIndex((dataString.rangeOfString(")", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)?.startIndex)!)
        
        dataString = dataString.stringByReplacingOccurrencesOfString("\n", withString: "")
        dataString = dataString.stringByReplacingOccurrencesOfString("\t", withString: "")
        
        let trimmedData = dataString.dataUsingEncoding(NSUTF8StringEncoding)
        
        return trimmedData
    }
}