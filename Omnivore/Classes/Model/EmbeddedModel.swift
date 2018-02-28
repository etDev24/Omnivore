//
//  EmbeddedModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation

class EmbeddedModel: JSONCompatible {
    var locations: [LocationModel]
    var price_levels: [PriceLevelModel]
    var menu_categories: [MenuCategoryModel]
    var option_sets: [OptionSetModel]
    var modifiers: [ModifierModel]

    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        locations = (json["locations"] as? [[String: Any]] ?? []).flatMap{LocationModel(json: $0)}
        price_levels = (json["price_levels"] as? [[String: Any]] ?? []).flatMap{PriceLevelModel(json: $0)}
        menu_categories = (json["menu_categories"] as? [[String: Any]] ?? []).flatMap{MenuCategoryModel(json: $0)}
        option_sets = (json["option_sets"] as? [[String: Any]] ?? []).flatMap{OptionSetModel(json: $0)}
        modifiers = (json["modifiers"] as? [[String: Any]] ?? []).flatMap{ModifierModel(json: $0)}
    }



    required convenience init() {
        self.init(json: [:])!
    }



    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(locations: [LocationModel], price_levels: [PriceLevelModel], menu_categories: [MenuCategoryModel], option_sets: [OptionSetModel], modifiers: [ModifierModel]) {
        self.locations = locations
        self.price_levels = price_levels
        self.menu_categories = menu_categories
        self.option_sets = option_sets
        self.modifiers = modifiers
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["locations"] = locations.map{$0.jsonDictionary()}
        dict["price_levels"] = price_levels.map{$0.jsonDictionary()}
        dict["menu_categories"] = menu_categories.map{$0.jsonDictionary()}
        dict["option_sets"] = option_sets.map{$0.jsonDictionary()}
        dict["modifiers"] = modifiers.map{$0.jsonDictionary()}
        return dict
    }
    
}



