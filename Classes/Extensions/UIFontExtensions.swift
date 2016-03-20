//
//  UIFontExtensions.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    public class func regularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIDisplay-Regular", size: size)!
    }
    
    public class func lightFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIDisplay-Light", size: size)!
    }
    
    public class func mediumFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIDisplay-Medium", size: size)!
    }
}
