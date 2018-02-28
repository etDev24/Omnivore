//
//  Links.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class Links: JSONCompatible {
    var revenue_centers: LinkModel
    var price_check: LinkModel
    var jobs: LinkModel
    var employees: LinkModel
    var order_types: LinkModel
    var tables: LinkModel
    var menu: LinkModel
    var auth: LinkModel
    var clock_entries: LinkModel
    var discounts: LinkModel
    var tender_types: LinkModel
    
    //Menu Object
    var items: LinkModel
    var modifier_groups: LinkModel
    var categories: LinkModel
    var modifiers: LinkModel
    
    //Menu links
    var menu_categories : LinkModel
    var option_sets : LinkModel
    var price_levels : LinkModel
    
    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        revenue_centers = LinkModel(json: json["revenue_centers"] as? [String: Any]) ?? LinkModel()
        price_check = LinkModel(json: json["price_check"] as? [String: Any]) ?? LinkModel()
        jobs = LinkModel(json: json["jobs"] as? [String: Any]) ?? LinkModel()
        employees = LinkModel(json: json["employees"] as? [String: Any]) ?? LinkModel()
        order_types = LinkModel(json: json["order_types"] as? [String: Any]) ?? LinkModel()
        tables = LinkModel(json: json["tables"] as? [String: Any]) ?? LinkModel()
        menu = LinkModel(json: json["menu"] as? [String: Any]) ?? LinkModel()
        auth = LinkModel(json: json["auth"] as? [String: Any]) ?? LinkModel()
        clock_entries = LinkModel(json: json["clock_entries"] as? [String: Any]) ?? LinkModel()
        discounts = LinkModel(json: json["discounts"] as? [String: Any]) ?? LinkModel()
        tender_types = LinkModel(json: json["tender_types"] as? [String: Any]) ?? LinkModel()
        
        //Menu Object
        items = LinkModel(json: json["items"] as? [String: Any]) ?? LinkModel()
        modifier_groups = LinkModel(json: json["modifier_groups"] as? [String: Any]) ?? LinkModel()
        categories = LinkModel(json: json["categories"] as? [String: Any]) ?? LinkModel()
        modifiers = LinkModel(json: json["modifiers"] as? [String: Any]) ?? LinkModel()
        
        //Menu links
        menu_categories = LinkModel(json: json["menu_categories"] as? [String: Any]) ?? LinkModel()
        option_sets = LinkModel(json: json["option_sets"] as? [String: Any]) ?? LinkModel()
        price_levels = LinkModel(json: json["price_levels"] as? [String: Any]) ?? LinkModel()
    }



    required convenience init() {
        self.init(json: [:])!
    }



    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(revenue_centers: LinkModel, price_check: LinkModel, jobs: LinkModel, employees: LinkModel, order_types: LinkModel, tables: LinkModel, menu: LinkModel, auth: LinkModel, clock_entries: LinkModel, discounts: LinkModel, tender_types: LinkModel, menu_categories : LinkModel, option_sets: LinkModel, price_levels: LinkModel, items: LinkModel, modifier_groups: LinkModel, categories: LinkModel, modifiers: LinkModel) {
        self.revenue_centers = revenue_centers
        self.price_check = price_check
        self.jobs = jobs
        self.employees = employees
        self.order_types = order_types
        self.tables = tables
        self.menu = menu
        self.auth = auth
        self.clock_entries = clock_entries
        self.discounts = discounts
        self.tender_types = tender_types
        
        self.items = items
        self.modifier_groups = modifier_groups
        self.categories = categories
        self.modifiers = modifiers
        
        self.menu_categories = menu_categories
        self.option_sets = option_sets
        self.price_levels = price_levels
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["revenue_centers"] = revenue_centers.jsonDictionary()
        dict["price_check"] = price_check.jsonDictionary()
        dict["jobs"] = jobs.jsonDictionary()
        dict["employees"] = employees.jsonDictionary()
        dict["order_types"] = order_types.jsonDictionary()
        dict["tables"] = tables.jsonDictionary()
        dict["menu"] = menu.jsonDictionary()
        dict["auth"] = auth.jsonDictionary()
        dict["clock_entries"] = clock_entries.jsonDictionary()
        dict["discounts"] = discounts.jsonDictionary()
        dict["tender_types"] = tender_types.jsonDictionary()
        
        dict["items"] = items.jsonDictionary()
        dict["modifier_groups"] = modifier_groups.jsonDictionary()
        dict["categories"] = categories.jsonDictionary()
        dict["modifiers"] = modifiers.jsonDictionary()
        
        dict["menu_categories"] = menu_categories.jsonDictionary()
        dict["option_sets"] = option_sets.jsonDictionary()
        dict["price_levels"] = price_levels.jsonDictionary()
        
        return dict
    }



}



