//
//  Meta.swift
//  EvrythngiOS
//
//  Created by JD Castro on 29/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

public final class Meta: ALSwiftyJSONAble {
    
    public var method: String?
    public var score: Int = 0
    public var value: String?
    public var type: String?
    
    public var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["method"] = self.method
            dict["score"] = self.score
            dict["value"] = self.value
            dict["type"] = self.type
            return JSON(dictionary: dict)
        }
    }
    
    public init() {
        
    }
    
    public convenience init?(jsonData: JSON) {
        self.init()
        self.jsonData = jsonData
        self.method = jsonData["method"].string
        self.score = jsonData["score"].intValue
        self.value = jsonData["value"].string
        self.type = jsonData["type"].string
    }
}
