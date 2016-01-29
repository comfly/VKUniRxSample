//
//  Tweet.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 27/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import Foundation

struct Tweet {
    let id: String
    let author: Author
    let text: String
    
    init?(fromDictionary dict: [String: AnyObject]) {
        guard
            let id = dict["id_str"] as? String,
            let text = dict["text"] as? String,
            let author = Author(fromDictionary: dict["user"] as! [String: AnyObject])
        else { return nil }
        
        self.id = id
        self.text = text
        self.author = author
    }
    
}
