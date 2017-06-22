//
//  Credentials.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

public final class Credentials: ALSwiftyJSONAble {

    public var evrythngUser: String?
    public var evrythngApiKey: String?
    public var activationCode: String?
    public var email: String?
    public var password: String?
    public var status: CredentialStatus?
    
    public var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["evrythngUser"] = self.evrythngUser
            dict["evrythngApiKey"] = self.evrythngApiKey
            dict["activationCode"] = self.activationCode
            dict["email"] = self.email
            dict["password"] = self.password
            dict["status"] = self.status?.rawValue
            return JSON(dictionary: dict)
        }
    }
    
    public required init() {
        
    }
    
    public convenience init?(jsonData: JSON) {
        self.init()
        self.jsonData = jsonData
        self.evrythngUser = jsonData["evrythngUser"].string
        self.evrythngApiKey = jsonData["evrythngApiKey"].string
        self.activationCode = jsonData["activationCode"].string
        self.email = jsonData["email"].string
        self.password = jsonData["password"].string
        self.status = CredentialStatus(rawValue: jsonData["status"].stringValue)
    }
    
    public convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
}

public enum CredentialStatus: String{
    case Active = "active"
    case Inactive = "inactive"
    case Anonymous = "anonymous"
}
