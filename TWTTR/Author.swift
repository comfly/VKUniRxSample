//
//  Author.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 27/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import Foundation


struct Author {
    let name: String
    let imageURL: NSURL
    
    init?(fromDictionary dict: [String: AnyObject]) {
        guard
            let name = dict["name"] as? String,
            let imageURLString = dict["profile_image_url"] as? String,
            let imageURL = NSURL(string: imageURLString)
        else { return nil }
        
        self.init(name: name, imageURL: imageURL)
    }
    
    init(name: String, imageURL: NSURL) {
        self.name = name
        self.imageURL = imageURL
    }
}
