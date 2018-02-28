//
//  MenuItemModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class MenuItemModel: JSONCompatible {
    var price_levels: [PriceLevelModel]
    var menu_categories: [MenuCategoryModel]
    var option_sets: [OptionSetModel]
    var name: String
    var id: String
    var stock : String
    var pos_id: String
    var statusOpen: Bool
    var price_per_unit: Float?

    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        price_levels = (json["price_levels"] as? [[String: Any]] ?? []).flatMap{PriceLevelModel(json: $0)}
        menu_categories = (json["menu_categories"] as? [[String: Any]] ?? []).flatMap{MenuCategoryModel(json: $0)}
        option_sets = (json["option_sets"] as? [[String: Any]] ?? []).flatMap{OptionSetModel(json: $0)}
        name = json["name"] as? String ?? ""
        id = json["id"] as? String ?? ""
        pos_id = json["pos_id"] as? String ?? ""
        stock = json["in_stock"] as? String ?? ""
        statusOpen = json["open"] as? Bool ?? false
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



    init(price_levels: [PriceLevelModel], menu_categories: [MenuCategoryModel], option_sets: [OptionSetModel], name: String, id: String, pos_id: String, stock: String, statusOpen: Bool, price_per_unit: Float?) {
        self.price_levels = price_levels
        self.menu_categories = menu_categories
        self.option_sets = option_sets
        self.name = name
        self.id = id
        self.pos_id = pos_id
        self.stock = stock
        self.statusOpen = statusOpen
        self.price_per_unit = price_per_unit
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["price_levels"] = price_levels.map{$0.jsonDictionary()}
        dict["menu_categories"] = menu_categories.map{$0.jsonDictionary()}
        dict["option_sets"] = option_sets.map{$0.jsonDictionary()}
        dict["name"] = name
        dict["id"] = id
        dict["pos_id"] = pos_id
        dict["in_stock"] = stock
        dict["open"] = statusOpen
        dict["price_per_unit"] = price_per_unit
        return dict
    }



}



