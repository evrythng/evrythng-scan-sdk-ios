//
//  Product.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

open class Product: DurableResourceModel, ALSwiftyJSONAble {

    var name: String?
    var brand: String?
    var description: String?
    var url: String?
    var categories: Array<String>?
    var properties: Dictionary<String, AnyObject>?
    var photos: Array<String>?
    var identifiers: Dictionary<String, String>?
    
    required public init?(jsonData:JSON){
        super.init(jsonData: jsonData)
        self.name = jsonData["name"].stringValue
        self.brand = jsonData["brand"].stringValue
        self.description = jsonData["description"].stringValue
        self.url = jsonData["url"].stringValue
        self.categories = jsonData["categories"].arrayObject as? Array<String>
        self.properties = jsonData["properties"].dictionaryObject as Dictionary<String, AnyObject>?
        self.photos = jsonData["photos"].arrayObject as? Array<String>
        self.identifiers = jsonData["identifiers"].dictionaryObject as? Dictionary<String, String>
    }
}
