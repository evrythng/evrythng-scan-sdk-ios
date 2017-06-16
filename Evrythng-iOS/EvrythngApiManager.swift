//
//  EvrythngApiManager.swift
//  EvrythngiOS
//
//  Created by JD Castro on 12/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public final class EvrythngApiManager {
    
    private var apiKey:String?
    
    public var scanService: ScanService {
        return ScanService(apiKey: self.apiKey)
    }
    
    public var thngService: ThngService {
        return ThngService(apiKey: self.apiKey)
    }
    
    public var authService: AuthService {
        return AuthService(apiKey: self.apiKey)
    }
    
    public var actionService: ActionService {
        return ActionService(apiKey: self.apiKey)
    }
    
    public var productService: ProductService {
        return ProductService(apiKey: self.apiKey)
    }
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        //UserDefaultsUtils.save(key: Constants.CachedAppToken, value: apiKey as AnyObject)
    }
    
    public init() {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let dimension1 = NSDictionary(contentsOfFile: path) {
                if let token = dimension1[Constants.AppToken] as? String{
                    self.apiKey = token
                }
            }
        }
    }
}
