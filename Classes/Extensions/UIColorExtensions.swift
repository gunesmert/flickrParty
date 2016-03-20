//
//  UIColorExtensions.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import SwiftHEXColors

extension UIColor {
    public class func lightGrayTextColor() -> UIColor {
        struct CachedColor { static var color :UIColor? = nil }
        
        if CachedColor.color == nil {
            CachedColor.color = UIColor(hexString: "#9B9B9B")!
        }
        
        return CachedColor.color!
    }
    
    public class func lightGraySeparatorColor() -> UIColor {
        struct CachedColor { static var color :UIColor? = nil }
        
        if CachedColor.color == nil {
            CachedColor.color = UIColor(hexString: "#E8E8E8")!
        }
        
        return CachedColor.color!
    }
}

