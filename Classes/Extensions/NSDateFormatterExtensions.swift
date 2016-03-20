//
//  NSDateFormatterExtensions.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    public class func formatter(withDateFormat formatterString: String) -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = formatterString
        
        return dateFormatter
    }
}
