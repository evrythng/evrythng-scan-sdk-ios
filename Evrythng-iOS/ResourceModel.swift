//
//  ResourceModel.swift
//  EvrythngiOS
//
//  Created by JD Castro on 22/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

open class ResourceModel {
    
    public var id: String?
    public var createdAt: Int64?
    public var customFields: Dictionary<String, AnyObject>?
    public var tags: Array<String>?
    public var scopes: ScopeResource?
    
    public var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["id"] = self.id
            dict["createdAt"] = self.createdAt
            dict["customFields"] = self.customFields
            dict["tags"] = self.tags
            dict["scopes"] = self.scopes?.jsonData?.dictionary
            
            return JSON(dictionary: dict)
        }
    }
    
    public required init() {
        
    }
    
    public convenience init?(jsonData:JSON){
        self.init()
        self.jsonData = jsonData
        self.id = jsonData["id"].stringValue
        self.createdAt = jsonData["createdAt"].int64Value
        self.customFields = jsonData["customFields"].dictionaryObject as [String:AnyObject]?
        self.tags = jsonData["tags"].arrayObject as? [String]
        
        if let scopes = jsonData["scopes"].string {
            self.scopes = ScopeResource(jsonData: JSON(scopes))
        }
    }
    
    public class func toString() -> NSString? {
        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string
    }
}
