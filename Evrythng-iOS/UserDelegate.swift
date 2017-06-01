//
//  UserDelegate.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import SwiftyJSON

public protocol UserDelegate: ALSwiftyJSONAble {
    var gender: Gender? { get set }
    var birthday: Date? { get set }
    var canLogin: Bool? { get set }
    var project: String? { get set }
    var app: String? { get set }
    var numberOfFriends: Int { get set }
    
    var jsonData: JSON? { get }
}

public enum Gender: String {
    case Female = "Female"
    case Male = "Male"
}
