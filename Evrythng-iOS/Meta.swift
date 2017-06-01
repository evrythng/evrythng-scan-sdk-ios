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
    
    public var jsonData: JSON?
    
    public var method: String?
    public var score: Int = 0
    public var value: String?
    public var type: String?
    
    public init?(jsonData: JSON) {
        self.jsonData = jsonData
        
        self.method = jsonData["method"].string
        self.score = jsonData["score"].intValue
        self.value = jsonData["value"].string
        self.type = jsonData["type"].string
    }
}
