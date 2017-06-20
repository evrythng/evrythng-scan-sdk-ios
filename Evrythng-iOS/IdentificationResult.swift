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

    public var redirections: Array<String>?
    public var thng: Thng?
    public var product: Product?
    
    public var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["redirections"] = self.redirections
            dict["thng"] = self.thng?.jsonData?.dictionaryObject
            dict["product"] = self.product?.jsonData?.dictionaryObject
            return JSON(dictionary: dict)
        }
    }
    
    public init() {
        
    }
    
    public convenience init?(jsonData: JSON) {
        self.init()
        self.jsonData = jsonData
        self.redirections = jsonData["redirections"].arrayObject as? Array<String>
        
        let jsThng = jsonData["thng"]
        let jsProduct = jsonData["product"]
        
        if(jsThng != JSON.null) {
            self.thng = Thng(jsonData: jsThng)
        }
        
        if(jsProduct != JSON.null) {
            self.product = Product(jsonData: jsProduct)
        }
    }
}
