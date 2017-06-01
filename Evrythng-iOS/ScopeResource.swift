//
//  ScopeResource.swift
//  EvrythngiOS
//
//  Created by JD Castro on 22/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

open class ScopeResource {
    
    var users: Array<String>?
    var projects: Array<String>?
    
    var jsonData: JSON? = nil
    
    public init() {
        
    }
    
    required public init?(jsonData:JSON){
        self.jsonData = jsonData
        self.users = jsonData["allU"].arrayObject as? [String]
        self.projects = jsonData["allP"].arrayObject as? [String]
    }
    
    public class func toString() -> NSString? {
        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string
    }

}
