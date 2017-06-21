//
//  DurableResourceModel.swift
//  EvrythngiOS
//
//  Created by JD Castro on 22/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

open class DurableResourceModel: ResourceModel {
    
    var updatedAt: Int64?
    
    public override var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["updatedAt"] = self.updatedAt
            
            var durableRsrcJson = JSON(dictionary: dict)
            do {
                try durableRsrcJson.merge(with: super.jsonData!)
            } catch {
                print("Error Merging User object: \(error.localizedDescription)")
            }
            return durableRsrcJson
        }
    }
    
    public required convenience init() {
        self.init()
    }
    
    public required convenience init?(jsonData:JSON){
        self.init()
        self.jsonData = jsonData
        self.updatedAt = jsonData["updatedAt"].int64Value
    }
}
