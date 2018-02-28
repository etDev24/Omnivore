//
//  Address.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class Address: JSONCompatible {
    var state: Any?
    var street2: Any?
    var city: Any?
    var street1: Any?
    var zip: Any?
    var country: Any?


    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        state = json["state"]
        street2 = json["street2"]
        city = json["city"]
        street1 = json["street1"]
        zip = json["zip"]
        country = json["country"]
    }



    required convenience init() {
        self.init(json: [:])!
    }



    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(state: Any?, street2: Any?, city: Any?, street1: Any?, zip: Any?, country: Any?) {
        self.state = state
        self.street2 = street2
        self.city = city
        self.street1 = street1
        self.zip = zip
        self.country = country
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["state"] = state
        dict["street2"] = street2
        dict["city"] = city
        dict["street1"] = street1
        dict["zip"] = zip
        dict["country"] = country
        return dict
    }



}



