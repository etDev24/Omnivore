//
//  MenuCategoryModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class MenuCategoryModel: JSONCompatible {
    var name: String
    var level: Int
    var id: String
    var pos_id: String
    var links: Links


    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        name = json["name"] as? String ?? ""
        level = json["level"] as? Int ?? 0
        id = json["id"] as? String ?? ""
        pos_id = json["pos_id"] as? String ?? ""
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



    init(name: String, level: Int, id: String, pos_id: String, links: Links) {
        self.name = name
        self.level = level
        self.id = id
        self.pos_id = pos_id
        self.links = links
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["name"] = name
        dict["level"] = level
        dict["id"] = id
        dict["pos_id"] = pos_id
        dict["_links"] = links.jsonDictionary()
        return dict
    }



}



