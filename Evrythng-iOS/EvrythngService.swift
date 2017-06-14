//
//  EvrythngService.swift
//  EvrythngiOS
//
//  Created by JD Castro on 13/06/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class EvrythngService {
    
    public var apiKey: String?
    
    required public init(apiKey: String?) {
        self.apiKey = apiKey
    }
    
    required public init() {
        
    }
}
