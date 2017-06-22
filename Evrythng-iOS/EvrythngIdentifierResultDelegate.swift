//
//  EvrythngScannerResultDelegate.swift
//  EvrythngiOS
//
//  Created by JD Castro on 09/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public protocol EvrythngIdentifierResultDelegate: class {
    func evrythngScannerWillStartIdentify()
    func evrythngScannerDidFinishIdentify(scanIdentificationsResponse: EvrythngScanIdentificationsResponse?, value: String, error: Error?)
}

extension EvrythngIdentifierResultDelegate {
    
}
