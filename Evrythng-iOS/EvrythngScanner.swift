//
//  EvrythngScanner.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//
//  Wrapper class to encapsulate barcode scanner module
//

import UIKit
import GoogleMobileVision
import KRProgressHUD

public enum EvrythngScannerModes: Int {
    case BARCODE = 1
    case QRCODE
}

public enum EvrythngScannerModeStrategy {
    case HIERARCHICAL // Will use the strategy from 1 ..< EvrythngScannerModes.rawValue
    case STATIC // Will only use the selected EvrythngScannerMode itself
}

public class EvrythngScanner {

    weak var delegate: EvrythngScannerResultDelegate?
    
    var barcodeScannerVC: EvrythngScannerVC
    var presentingVC: UIViewController?
    
    var scannerMode: EvrythngScannerModes = .QRCODE
    var scannerModeStrategy: EvrythngScannerModeStrategy = .HIERARCHICAL
    
    required public init(presentedBy presentingVC: UIViewController?) {
        self.presentingVC = presentingVC
        self.barcodeScannerVC = EvrythngScannerVC(nibName: "EvrythngScannerVC", bundle: Bundle(identifier: "com.imfreemobile.EvrythngiOS"))
    }
    
    convenience public init(presentedBy presentingVC: UIViewController?, withResultDelegate delegate: EvrythngScannerResultDelegate?) {
        self.init(presentedBy: presentingVC)
        self.presentingVC = presentingVC
        self.delegate = delegate
    }
    
    deinit {
        print("\(#function) EvrythngScanner")
    }
    
    //public final func identify(barcode: String, completionHandler: @escaping (_ result: String, _ error: Error?) -> Void) {
    public final func identify(barcode: String, format: GMVDetectorBarcodeFormat?, completionHandler: @escaping (_ scanIdentificationsResponse: EvrythngScanIdentificationsResponse?, _ error: Error?) -> Void) {
        
        if let scanType = EvrythngScanHelper.getScanTypeFrom(format: format!) {
            
            let method = scanType.getScanMethod()
            
            let apiManager = EvrythngApiManager()
            apiManager.scanService.evrythngScanOperator(scanType: scanType, scanMethod: method, value: barcode).execute { (scanIdentifactionsResponse, err) in
                completionHandler(scanIdentifactionsResponse, err)
            }
        } else {
            print("Unable to determine Scan Type")
        }
    }
    
    public final func identify(barcode: String) {
        //self.delegate?.didFinishScanResult(result: barcode, error: nil)
        self.delegate?.evrythngScannerDidFinishScan(scanIdentificationsResponse: nil, value: barcode, error: nil)
    }
    
    public final func scanBarcode() {
        self.barcodeScannerVC.evrythngScannerDelegate = self
        if let navPresentingVC = self.presentingVC?.navigationController {
            navPresentingVC.pushViewController(self.barcodeScannerVC, animated: true)
        } else {
             self.presentingVC?.present(self.barcodeScannerVC, animated: true, completion: nil)
        }
    }
    
    func dismissVC(viewController: UIViewController) {
        self.barcodeScannerVC.evrythngScannerDelegate = nil
        if let navPresentingVC = viewController.navigationController {
            navPresentingVC.popViewController(animated: true)
        } else {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}

extension EvrythngScanner: EvrythngScannerDelegate {
    
    public func didCancelScan(viewController: EvrythngScannerVC) {
        print("Did Cancel Scan")
        viewController.evrythngScannerDelegate = nil
    }
    
    public func willStartScan(viewController: EvrythngScannerVC) {
        print("Starting Capture")
    }
    
    public func didFinishScan(viewController: EvrythngScannerVC, value: String?, format: GMVDetectorBarcodeFormat?, error: Error?) {
        print("\(#function)")
        guard let err = error else {
            guard let barcodeVal = value else {
                print("Barcode Value is NULL")
                self.dismissVC(viewController: viewController)
                return
            }
            
            KRProgressHUD.show()
            //self.identify(barcode: val, completionHandler: { (result, err) in
            self.identify(barcode: barcodeVal, format: format, completionHandler: { (result, err) in
                KRProgressHUD.dismiss()
                self.dismissVC(viewController: viewController)
                //self.delegate?.didFinishScan(result: result, error: err)
                self.delegate?.evrythngScannerDidFinishScan(scanIdentificationsResponse: result, value: barcodeVal, error: err)
            })
            return
        }
        print("Err Localized Desc: \(err.localizedDescription)")
    }
}
