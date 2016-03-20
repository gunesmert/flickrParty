//
//  NSDataExtensions.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import Foundation

extension NSData {
    internal func jsonObjectRepresentation() -> AnyObject? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(self, options: .MutableContainers)
            
            return json
        } catch {
            print("Something went wrong")
        }
        
        return nil
    }
}
