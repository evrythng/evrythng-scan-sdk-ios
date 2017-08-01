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

public class EvrythngScanner {

    internal static let OPTIMAL_MOBILE_VISION_WIDTH_HEIGHT: CGFloat = 175
    
    weak var delegate: EvrythngIdentifierResultDelegate?
    
    var barcodeScannerVC: EvrythngScannerVC
    var presentingVC: UIViewController?
    
    required public init(presentedBy presentingVC: UIViewController?) {
        self.presentingVC = presentingVC
        self.barcodeScannerVC = EvrythngScannerVC(nibName: "EvrythngScannerVC", bundle: Bundle(identifier: "com.imfreemobile.EvrythngiOS"))
    }
    
    convenience public init(presentedBy presentingVC: UIViewController?, withResultDelegate delegate: EvrythngIdentifierResultDelegate?) {
        self.init(presentedBy: presentingVC)
        self.presentingVC = presentingVC
        self.delegate = delegate
    }
    
    deinit {
        if(Evrythng.DEBUGGING_ENABLED) {
            print("\(#function) EvrythngScanner")
        }
    }
    
    public final func identify(barcode: String, format: GMVDetectorBarcodeFormat?, completionHandler: @escaping (_ scanIdentificationsResponse: EvrythngScanIdentificationsResponse?, _ error: Error?) -> Void) {
        
        if let scanType = EvrythngScanHelper.getScanTypeFrom(format: format!) {
            
            let method = scanType.getScanMethod()
            
            let apiManager = EvrythngApiManager()
            apiManager.scanService.evrythngScanOperator(scanType: scanType, scanMethod: method, value: barcode).execute { (scanIdentifactionsResponse, err) in
                completionHandler(scanIdentifactionsResponse, err)
            }
        } else {
            if(Evrythng.DEBUGGING_ENABLED) {
                print("Unable to determine Scan Type")
            }
        }
    }
    
    public final func identify(barcode: String) {
        self.delegate?.evrythngScannerDidFinishIdentify(scanIdentificationsResponse: nil, value: barcode, error: nil)
    }
    
    public final func scanBarcode() {
        self.barcodeScannerVC.evrythngScannerDelegate = self
        if let navPresentingVC = self.presentingVC?.navigationController {
            navPresentingVC.pushViewController(self.barcodeScannerVC, animated: true)
        } else {
            self.presentingVC?.present(self.barcodeScannerVC, animated: true, completion: nil)
        }
    }
    
    public final func scanBarcodeImage(image: UIImage) {
        
        // Resize the image since MobileVision apparently cannot process high res images
        let resizedImage = self.resizeImage(image: image, newWidth: EvrythngScanner.OPTIMAL_MOBILE_VISION_WIDTH_HEIGHT)
        
        if let detector = GMVDetector(ofType: GMVDetectorTypeBarcode, options: nil) {
            if let barcodeFeatures:[GMVBarcodeFeature] = detector.features(in: resizedImage, options: nil) as? [GMVBarcodeFeature] {
                
                if(Evrythng.DEBUGGING_ENABLED) {
                    print ("Barcode Features Count: \(barcodeFeatures.count)")
                }
                
                let barcodeFeature = barcodeFeatures.last
                var barcodeRawValue = ""
                
                if (barcodeFeature != nil) {
                    let barcodeFormat = barcodeFeature!.format as GMVDetectorBarcodeFormat
                    barcodeRawValue = (barcodeFeature!.rawValue ?? "")!
                    
                    if(Evrythng.DEBUGGING_ENABLED) {
                        print("Detected \(barcodeFeatures.count) barcode(s) with Value: \(barcodeRawValue) Format: \(barcodeFormat)")
                    }
                    
                    if(!StringUtils.isStringEmpty(string: barcodeRawValue)) {
                        self.delegate?.evrythngScannerWillStartIdentify()
                        self.identify(barcode: barcodeRawValue, format: barcodeFormat, completionHandler: { (result, err) in
                            self.delegate?.evrythngScannerDidFinishIdentify(scanIdentificationsResponse: result, value: barcodeRawValue, error: err)
                        })
                    }
                    
                } else {
                    if(Evrythng.DEBUGGING_ENABLED) {
                        print ("No Detected Barcodes")
                    }
                    
                    self.delegate?.evrythngScannerDidFinishIdentify(scanIdentificationsResponse: nil, value: "", error: EvrythngError.NoDetectedBarcode)
                }
            } else {
                if(Evrythng.DEBUGGING_ENABLED) {
                    print("Unable to extract features from image")
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func dismissVC(viewController: UIViewController) {
        self.barcodeScannerVC.evrythngScannerDelegate = nil
        if let navPresentingVC = viewController.navigationController {
            
            if(navPresentingVC.childViewControllers.count == 0) {
                navPresentingVC.dismiss(animated: true, completion: nil)
            } else {
                navPresentingVC.popViewController(animated: true)
            }
        } else {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension EvrythngScanner: EvrythngScannerDelegate {
    
    public func didCancelScan(viewController: EvrythngScannerVC) {
        if(Evrythng.DEBUGGING_ENABLED) {
            print("Did Cancel Scan")
        }
        viewController.evrythngScannerDelegate = nil
    }
    
    public func willStartScan(viewController: EvrythngScannerVC) {
        if(Evrythng.DEBUGGING_ENABLED) {
            print("Starting Capture")
        }
    }
    
    public func didFinishScan(viewController: EvrythngScannerVC, value: String?, format: GMVDetectorBarcodeFormat?, error: Error?) {
        
        if(Evrythng.DEBUGGING_ENABLED) {
            print("\(#function)")
        }
        
        guard let err = error else {
            guard let barcodeVal = value else {
                if(Evrythng.DEBUGGING_ENABLED) {
                    print("Barcode Value is NULL")
                }
                self.dismissVC(viewController: viewController)
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.evrythngScannerWillStartIdentify()
            }
            self.identify(barcode: barcodeVal, format: format, completionHandler: { (result, err) in
                DispatchQueue.main.async {
                    self.dismissVC(viewController: viewController)
                    self.delegate?.evrythngScannerDidFinishIdentify(scanIdentificationsResponse: result, value: barcodeVal, error: err)
                }
            })
            return
        }
        if(Evrythng.DEBUGGING_ENABLED) {
            print("Err Localized Desc: \(err.localizedDescription)")
        }
    }
}
