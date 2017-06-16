//
//  ThngService.swift
//  EvrythngiOS
//
//  Created by JD Castro on 16/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class ThngService: EvrythngService {

    public func thngReader(thngId: String) -> ThngReader {
        return ThngReader(thngId: thngId)
    }
    
}
