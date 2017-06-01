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

    public var jsonData: JSON?
    
    public var evrythngUser: String?
    public var evrythngApiKey: String?
    public var activationCode: String?
    public var email: String?
    public var password: String?
    public var status: CredentialStatus?
    
    public init?(jsonData: JSON) {
        self.jsonData = jsonData
        
        self.evrythngUser = jsonData["evrythngUser"].string
        self.evrythngApiKey = jsonData["evrythngApiKey"].string
        self.activationCode = jsonData["activationCode"].string
        self.email = jsonData["email"].string
        self.password = jsonData["password"].string
        self.status = CredentialStatus(rawValue: jsonData["status"].stringValue)
    }
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public enum CredentialStatus: String{
    case Active = "active"
    case Inactive = "inactive"
    case Anonymous = "anonymous"
}
