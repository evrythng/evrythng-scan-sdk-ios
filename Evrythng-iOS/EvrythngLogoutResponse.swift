//
//  EvrythngLogoutResponse.swift
//  EvrythngiOS
//
//  Created by JD Castro on 29/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

public final class EvrythngLogoutResponse: ALSwiftyJSONAble {
    
    public var jsonData: JSON?
    public var logout: String?
    
    public init?(jsonData: JSON) {
        self.jsonData = jsonData
        self.logout = jsonData["logout"].string
    }
}
