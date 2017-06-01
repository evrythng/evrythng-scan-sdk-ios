//
//  EvrythngScanHelper.swift
//  EvrythngiOS
//
//  Created by JD Castro on 30/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import GoogleMobileVision

public final class EvrythngScanHelper {
    
    public static func getDetectionFormat(from gmvFeature: GMVFeature) -> GMVDetectorBarcodeFormat? {
        if case let barcodeFeature as GMVBarcodeFeature = gmvFeature {
            return barcodeFeature.format
        }
        return nil
    }
    
    public static func getScanTypeFrom(format: GMVDetectorBarcodeFormat) -> EvrythngScanTypes? {
        
        switch(format) {
            case GMVDetectorBarcodeFormat.code128:
                return EvrythngScanTypes.CODE_128
            case GMVDetectorBarcodeFormat.code39:
                return EvrythngScanTypes.CODE_39
            case GMVDetectorBarcodeFormat.code93:
                return EvrythngScanTypes.CODE_93
            case GMVDetectorBarcodeFormat.codaBar:
                return EvrythngScanTypes.CODABAR
            case GMVDetectorBarcodeFormat.EAN13:
                return EvrythngScanTypes.EAN_13
            case GMVDetectorBarcodeFormat.EAN8:
                return EvrythngScanTypes.EAN_8
            case GMVDetectorBarcodeFormat.ITF:
                return EvrythngScanTypes.ITF_14
            case GMVDetectorBarcodeFormat.UPCA:
                return EvrythngScanTypes.UPC_A
            case GMVDetectorBarcodeFormat.UPCE:
                return EvrythngScanTypes.UPC_E
            case GMVDetectorBarcodeFormat.dataMatrix:
                fallthrough
            case GMVDetectorBarcodeFormat.qrCode:
                fallthrough
            case GMVDetectorBarcodeFormat.PDF417:
                fallthrough
            case GMVDetectorBarcodeFormat.aztec:
                return EvrythngScanTypes.QR_CODE // TODO: Re-check
            default:
                return nil
        }
    }

}
