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
    
    public var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["evrythngUser"] = self.id
            dict["gender"] = self.gender?.rawValue
            
            if let birthday = self.birthday {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dict["birthday"] = formatter.string(from: birthday)
            }
            dict["canLogin"] = self.canLogin
            dict["project"] = self.project
            dict["app"] = self.app
            dict["numberOfFriends"] = self.numberOfFriends
            return JSON(dictionary: dict)
        }
    }
    
    public required init() {
        
    }
    
    public required convenience init?(jsonData:JSON){
        self.init()
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
