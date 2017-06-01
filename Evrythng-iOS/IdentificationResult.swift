//
//  IdentificationResult.swift
//  EvrythngiOS
//
//  Created by JD Castro on 29/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

public final class IdentificationResult: ALSwiftyJSONAble {
    
    public var jsonData: JSON?
    
    public var redirections: Array<String>?
    public var thng: Thng?
    public var product: Product?
    
    public init?(jsonData: JSON) {
        self.jsonData = jsonData
        self.redirections = jsonData["redirections"].arrayObject as? Array<String>
        self.thng = Thng(jsonData: jsonData["thng"])
        self.product = Product(jsonData: jsonData["product"])
    }
}
