//
//  AbstractUser.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

public class AbstractUser: UserDelegate {
    
    public var id: String? = nil
    public var gender: Gender? = nil
    public var birthday: Date? = nil
    public var canLogin: Bool? = false
    public var project: String? = nil
    public var app: String? = nil
    public var numberOfFriends = 0
    
    public var jsonData: JSON? = nil
    
    public init() {
        
    }
    
    required public init?(jsonData:JSON){
        self.jsonData = jsonData
        self.id = jsonData["evrythngUser"].stringValue
        self.gender = Gender(rawValue: jsonData["gender"].stringValue)
        self.birthday = jsonData["birthday"].date(format: "yyyy-MM-dd HH:mm:ss")
        self.canLogin = jsonData["canLogin"].boolValue
        self.project = jsonData["project"].stringValue
        self.app = jsonData["app"].stringValue
        self.numberOfFriends = jsonData["numberOfFriends"].intValue
    }
    
    public class func toString() -> NSString? {
        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string
    }
}
