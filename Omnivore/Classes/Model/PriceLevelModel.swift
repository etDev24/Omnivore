//
//  PriceLevelModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class PriceLevelModel: JSONCompatible {
    var links: Links
    var name: String
    var id: String
    var price_per_unit: Float


    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        links = Links(json: json["_links"] as? [String: Any]) ?? Links()
        name = json["name"] as? String ?? ""
        id = json["id"] as? String ?? ""
        price_per_unit = json["price_per_unit"] as? Float ?? 0.0
    }



    required convenience init() {
        self.init(json: [:])!
    }



    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(links: Links, name: String, id: String, price_per_unit: Float) {
        self.links = links
        self.name = name
        self.id = id
        self.price_per_unit = price_per_unit
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["_links"] = links.jsonDictionary()
        dict["name"] = name
        dict["id"] = id
        dict["price_per_unit"] = price_per_unit
        return dict
    }



}



