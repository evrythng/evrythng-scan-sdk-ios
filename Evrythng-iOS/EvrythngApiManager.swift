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
        return ScanService()
    }
    
    public var thngService: ThngService {
        return ThngService()
    }
    
    public var authService: AuthService {
        return AuthService()
    }
    
    public var actionService: ActionService {
        return ActionService()
    }
    
    public var productService: ProductService {
        return ProductService()
    }
    
    public init(apiKey: String) {
        self.apiKey = apiKey
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
