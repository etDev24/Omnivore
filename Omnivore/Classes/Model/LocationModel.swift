//
//  LocationModel.swift
//  Omnivore
//
//  Created by Muhammad Umair on 27/02/18.
//  Copyright © 2017 Eureka. All rights reserved.


import Foundation


class LocationModel: JSONCompatible {
    var name: String
    var development: Bool
    var google_place_id: Any?
    var display_name: String
    var links: Links
    var concept_name: String
    var pos_type: String
    var address: Address
    var website: Any?
    var latitude: Any?
    var status: String
    var modified: Int
    var id: String
    var created: Int
    var timezone: Any?
    var phone: Any?
    var owner: String
    var longitude: Any?


    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        name = json["name"] as? String ?? ""
        development = json["development"] as? Bool ?? false
        google_place_id = json["google_place_id"]
        display_name = json["display_name"] as? String ?? ""
        links = Links(json: json["_links"] as? [String: Any]) ?? Links()
        concept_name = json["concept_name"] as? String ?? ""
        pos_type = json["pos_type"] as? String ?? ""
        address = Address(json: json["address"] as? [String: Any]) ?? Address()
        website = json["website"]
        latitude = json["latitude"]
        status = json["status"] as? String ?? ""
        modified = json["modified"] as? Int ?? 0
        id = json["id"] as? String ?? ""
        created = json["created"] as? Int ?? 0
        timezone = json["timezone"]
        phone = json["phone"]
        owner = json["owner"] as? String ?? ""
        longitude = json["longitude"]
    }



    required convenience init() {
        self.init(json: [:])!
    }



    required convenience init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(name: String, development: Bool, google_place_id: Any?, display_name: String, links: Links, concept_name: String, pos_type: String, address: Address, website: Any?, latitude: Any?, status: String, modified: Int, id: String, created: Int, timezone: Any?, phone: Any?, owner: String, longitude: Any?) {
        self.name = name
        self.development = development
        self.google_place_id = google_place_id
        self.display_name = display_name
        self.links = links
        self.concept_name = concept_name
        self.pos_type = pos_type
        self.address = address
        self.website = website
        self.latitude = latitude
        self.status = status
        self.modified = modified
        self.id = id
        self.created = created
        self.timezone = timezone
        self.phone = phone
        self.owner = owner
        self.longitude = longitude
    }



    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["name"] = name
        dict["development"] = development
        dict["google_place_id"] = google_place_id
        dict["display_name"] = display_name
        dict["_links"] = links.jsonDictionary()
        dict["concept_name"] = concept_name
        dict["pos_type"] = pos_type
        dict["address"] = address.jsonDictionary()
        dict["website"] = website
        dict["latitude"] = latitude
        dict["status"] = status
        dict["modified"] = modified
        dict["id"] = id
        dict["created"] = created
        dict["timezone"] = timezone
        dict["phone"] = phone
        dict["owner"] = owner
        dict["longitude"] = longitude
        return dict
    }



}



