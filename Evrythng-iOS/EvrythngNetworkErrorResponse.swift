//
//  EvrythngNetworkErrorResponse.swift
//  EvrythngiOS
//
//  Created by JD Castro on 24/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON


open class EvrythngNetworkErrorResponse: Error, ALSwiftyJSONAble  {
    
    open var jsonData: JSON?
    
    open var moreInfo: String?
    open var responseStatusCode: Int?
    open var code: Int64?
    open var errors: Array<String>?
    
    required public init?(jsonData:JSON){
        self.jsonData = jsonData
        self.moreInfo = jsonData["moreInfo"].string
        self.responseStatusCode = jsonData["status"].int
        self.code = jsonData["code"].int64
        self.errors = jsonData["errors"].arrayObject as? [String]
    }
    
}
