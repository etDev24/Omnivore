//
//  OptionSetModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class OptionSetModel: JSONCompatible {
    var maximum: Int
    var isRequired: Bool
    var minimum: Int
    var id: String
    var links: Links


    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        maximum = json["maximum"] as? Int ?? 0
        isRequired = json["required"] as? Bool ?? false
        minimum = json["minimum"] as? Int ?? 0
        id = json["id"] as? String ?? ""
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



    init(maximum: Int, isRequired: Bool, minimum: Int, id: String, links: Links) {
        self.maximum = maximum
        self.isRequired = isRequired
        self.minimum = minimum
        self.id = id
        self.links = links
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["maximum"] = maximum
        dict["required"] = isRequired
        dict["minimum"] = minimum
        dict["id"] = id
        dict["_links"] = links.jsonDictionary()
        return dict
    }



}



