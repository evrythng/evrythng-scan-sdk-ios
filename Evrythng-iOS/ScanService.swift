//
//  ScanService.swift
//  EvrythngiOS
//
//  Created by JD Castro on 16/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class ScanService: EvrythngService {
    
    public func evrythngScanOperator(scanType: EvrythngScanTypes, scanMethod: EvrythngScanMethods, value: String) -> EvrythngScanOperator {
        
        let evtOperator = EvrythngScanOperator(scanType: scanType, scanMethod: scanMethod, value: value)
        evtOperator.apiKey = self.apiKey
        
        return evtOperator
    }
    
}
