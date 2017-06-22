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
    
    public override var jsonData: JSON? {
        set {
            
        }
        get {
            var dict: [String:Any] = [:]
            dict["email"] = self.email
            dict["password"] = self.password
            dict["firstName"] = self.firstName
            dict["lastName"] = self.lastName
            dict["activationCode"] = self.activationCode
            dict["status"] = self.status
            var userJson = JSON(dictionary: dict)
            do {
                try userJson.merge(with: super.jsonData!)
            } catch {
                print("Error Merging User object: \(error.localizedDescription)")
            }
            return userJson
        }
    }
    
    public required init() {
        super.init()
    }
    
    public required convenience init?(jsonData: JSON) {
        self.init()
        self.jsonData = jsonData
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
