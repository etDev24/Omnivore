//
//  ModifierModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 28/02/18.
//  Copyright © 2017 Eureka. All rights reserved.

import Foundation


struct ModifierModel: JSONCompatible {
    var embedded: EmbeddedModel
    var name: String
    var id: String
    var pos_id: String
    var links: Links
    var statusOpen: Bool
    var price_per_unit: Float?
    var isSelected : Bool


    init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        embedded = EmbeddedModel(json: json["_embedded"] as? [String: Any]) ?? EmbeddedModel()
        name = json["name"] as? String ?? ""
        id = json["id"] as? String ?? ""
        pos_id = json["pos_id"] as? String ?? ""
        links = Links(json: json["_links"] as? [String: Any]) ?? Links()
        statusOpen = json["open"] as? Bool ?? false
        price_per_unit = json["price_per_unit"] as? Float ?? 0.0
        isSelected = false
    }



    init() {
        self.init(json: [:])!
    }



    init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(embedded: EmbeddedModel, name: String, id: String, pos_id: String, links: Links, statusOpen: Bool, price_per_unit: Float?) {
        self.embedded = embedded
        self.name = name
        self.id = id
        self.pos_id = pos_id
        self.links = links
        self.statusOpen = statusOpen
        self.price_per_unit = price_per_unit
        self.isSelected = false
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["_embedded"] = embedded.jsonDictionary()
        dict["name"] = name
        dict["id"] = id
        dict["pos_id"] = pos_id
        dict["_links"] = links.jsonDictionary()
        dict["open"] = statusOpen
        dict["price_per_unit"] = price_per_unit
        dict["isSelected"] = isSelected
        return dict
    }



}



