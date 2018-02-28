//
//  ModifierModel.swift
//  Omnivore Demo
//
//  Created by apple on 2/27/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation

class ModifierGroupModel: JSONCompatible {
    var embedded: EmbeddedModel
    var name: String
    var id: String
    var pos_id: String
    var links: Links
    
    
    required init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        embedded = EmbeddedModel(json: json["_embedded"] as? [String: Any]) ?? EmbeddedModel()
        name = json["name"] as? String ?? ""
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
    
    
    
    init(embedded: EmbeddedModel, name: String, id: String, pos_id: String, links: Links) {
        self.embedded = embedded
        self.name = name
        self.id = id
        self.pos_id = pos_id
        self.links = links
    }
    
    
    
    func jsonDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["_embedded"] = embedded.jsonDictionary()
        dict["name"] = name
        dict["id"] = id
        dict["pos_id"] = pos_id
        dict["_links"] = links.jsonDictionary()
        return dict
    }
    
}




