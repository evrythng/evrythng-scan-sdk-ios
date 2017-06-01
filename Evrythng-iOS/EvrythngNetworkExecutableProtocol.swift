//
//  EvrythngNetworkExecutableProtocol.swift
//  EvrythngiOS
//
//  Created by JD Castro on 12/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya_SwiftyJSONMapper
import Moya
import MoyaSugar

public protocol EvrythngNetworkExecutableProtocol {
    
    associatedtype ALSwiftyJSNONAbleInstance: ALSwiftyJSONAble
    //func execute<T>(completionHandler: @escaping (T?,Swift.Error?) -> Void) where T: ALSwiftyJSONAble
    func execute(completionHandler: @escaping (ALSwiftyJSNONAbleInstance?, Swift.Error?) -> Void)
    
    //func provider() -> MoyaSugarProvider<EvrythngNetworkService>
    func getDefaultProvider() -> EvrythngMoyaProvider<EvrythngNetworkService>
}

extension EvrythngNetworkExecutableProtocol {
    public func getDefaultProvider() -> EvrythngMoyaProvider<EvrythngNetworkService> {
        return EvrythngMoyaProvider<EvrythngNetworkService>()
    }
}
