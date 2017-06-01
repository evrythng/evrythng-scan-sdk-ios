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
    
    required public init?(jsonData:JSON){
        super.init(jsonData: jsonData)
        self.updatedAt = jsonData["updatedAt"].int64Value
    }
}
