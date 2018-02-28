//
//  LinkModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class LinkModel: JSONCompatible {
    var type: String
    var href: String


    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        type = json["type"] as? String ?? ""
        href = json["href"] as? String ?? ""
    }



    required convenience init() {
        self.init(json: [:])!
    }



    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(type: String, href: String) {
        self.type = type
        self.href = href
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["type"] = type
        dict["href"] = href
        return dict
    }



}



