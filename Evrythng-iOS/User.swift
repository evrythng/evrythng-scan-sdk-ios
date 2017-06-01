//
//  User.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

public final class User: AbstractUser {
    
    public var email: String?
    public var password: String?
    public var firstName: String?
    public var lastName: String?
    public private(set) var activationCode: String?
    public private(set) var status: String?
    
    required public init?(jsonData: JSON) {
        super.init(jsonData: jsonData)
        
        self.email = jsonData["email"].stringValue
        self.password = jsonData["password"].stringValue
        self.firstName = jsonData["firstName"].stringValue
        self.lastName = jsonData["lastName"].stringValue
        self.activationCode = jsonData["activationCode"].stringValue
        self.status = jsonData["status"].stringValue
    }
    
    private func toJSON() -> JSON {
        
        var jsonData: [String: Any] = [:]
        
        if let email = self.email {
            jsonData["email"] = email
        }
        
        if let password = self.password {
            jsonData["password"] = password
        }
        
        if let firstName = self.firstName {
            jsonData["firstName"] = firstName
        }
        
        if let lastName = self.lastName {
            jsonData["lastName"] = lastName
        }
        
        if let activationCode = self.activationCode {
            jsonData["activationCode"] = activationCode
        }
        
        if let status = self.status {
            jsonData["status"] = status
        }
    
        return JSON(jsonData: jsonData)
    }
}
