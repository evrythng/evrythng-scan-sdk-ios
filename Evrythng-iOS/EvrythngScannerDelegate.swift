//
//  EvrythngScannerProtocol.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import GoogleMobileVision

public protocol EvrythngScannerDelegate: class {
    func didCancelScan(viewController: EvrythngScannerVC)
    func didFinishScan(viewController: EvrythngScannerVC, value: String?, format: GMVDetectorBarcodeFormat?, error: Error?) -> Void
    func willStartScan(viewController: EvrythngScannerVC) -> Void
}

extension EvrythngScannerDelegate {
    
}
