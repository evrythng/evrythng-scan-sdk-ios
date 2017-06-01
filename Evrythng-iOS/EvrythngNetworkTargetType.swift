//
//  EvrythngNetworkTargetType.swift
//  EvrythngiOS
//
//  Created by JD Castro on 27/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya
import MoyaSugar

public protocol EvrythngNetworkTargetType: SugarTargetType {
    var sampleResponseClosure: (()-> EndpointSampleResponse) { get }
}
