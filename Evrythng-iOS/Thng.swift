//
//  Thng.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

open class Thng: DurableResourceModel, ALSwiftyJSONAble {
    
    public var name: String?
    public var description: String?
    public var batch: String?
    public var product: String? //Reference to Product.id
    public var createdByTask: String?
    public var identifiers: Dictionary<String, String>?
    public var collections: Array<String>?
    public var properties: Dictionary<String, AnyObject>?
    
    public override var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["name"] = self.name
            dict["description"] = self.description
            dict["batch"] = self.batch
            dict["product"] = self.product
            dict["createdByTask"] = self.createdByTask
            dict["identifiers"] = self.identifiers
            dict["collections"] = self.collections
            dict["properties"] = self.properties
            
            var thngJson = JSON(dictionary: dict)
            do {
                try thngJson.merge(with: super.jsonData!)
            } catch {
                print("Error Merging Thng object: \(error.localizedDescription)")
            }
            return thngJson
        }
    }
    
    public required init() {
        super.init()
    }
    
    public required convenience init?(jsonData:JSON){
        self.init()
        self.jsonData = jsonData
        self.name = jsonData["name"].string
        self.description = jsonData["description"].string
        self.batch = jsonData["batch"].string
        self.product = jsonData["product"].string
        self.createdByTask = jsonData["createdByTask"].string
        
        self.identifiers = jsonData["identifiers"].dictionaryObject as? Dictionary<String, String>
        self.collections = jsonData["collections"].arrayObject as? [String]
        self.properties = jsonData["properties"].dictionaryObject as Dictionary<String, AnyObject>?
    }
}
