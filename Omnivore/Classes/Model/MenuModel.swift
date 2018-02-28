//
//  MenuModel.swift
//  Omnivore Demo
//
//  Created by apple on 2/27/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation

class MenuModel: JSONCompatible {
    var links: Links
    
    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        links = Links(json: json["_links"] as? [String: Any]) ?? Links()
    }
    
    required convenience init() {
        self.init(json: [:])!
    }
    
    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }
    
    init(links: Links) {
        self.links = links
    }
    
    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["_links"] = links.jsonDictionary()
        return dict
    }
}
