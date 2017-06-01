//
//  EvrythngScannerVC.swift
//  EvrythngiOS
//
//  Created by JD Castro on 17/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import GoogleMobileVision

public class EvrythngScannerVC: UIViewController {

    // MARK: - Private Variables
    
    private var serialQueue = DispatchQueue(label: "evrythng_scanner_vc_queue", qos: .userInitiated)
    var cameraFrameExtractor: EvrythngCameraFrameExtractor!
    var detected = false
    
    // MARK: - Public Variables
    
    // We do not declare as `weak` reference type because the implementing ViewController
    // which declares / holds the EvrythngScanner instance will hold EvrthngScanner's instance.
    // Hence, this delegate should be manually set to nil to avoid memory leak
    var evrythngScannerDelegate: EvrythngScannerDelegate?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - IBActions
    
    // MARK: - View Controller Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EvrythngScanner"
        
        self.cameraFrameExtractor = EvrythngCameraFrameExtractor()
        self.cameraFrameExtractor.delegate = self
        self.detected = false;
    }
    
    func scanImage(ciImage: CIImage?) {
        
        self.serialQueue.async {
            
            var ciimg:CIImage? = nil
            
            constructCIImage:
                if (ciImage != nil) {
                ciimg = ciImage
            } else { // Sample only
                let actualUrl = "http://cdnqrcgde.s3-eu-west-1.amazonaws.com/wp-content/uploads/2013/11/jpeg.jpg" //http://imgur.com/bcdARJf.jpg
                
                guard let url:NSURL = NSURL(string:actualUrl) else {
                    ciimg = nil
                    break constructCIImage
                }
                ciimg = CIImage(contentsOf:url as URL)
            }
            
            guard let ciImageToProcess = ciimg, let cid:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow]) else {
                print("CIImage is NIL or CIDetector not Available")
                return
            }
            
            let results:NSArray = cid.features(in: ciImageToProcess) as NSArray
            
            if(results.count > 0) {
                if(!self.detected) {
                    DispatchQueue.main.async {
                        if let qr = results.firstObject as? CIQRCodeFeature, let messageString = qr.messageString {
                            
                            self.detected = true
                            self.evrythngScannerDelegate?.didFinishScan(viewController: self, value: messageString, format: nil, error: nil)
                            //print("Hala: Finish Scan2 \(self.evrythngScannerDelegate != nil)")
                        }
                    }
                    
                }
                //strongSelf.printResults(withResults: results)
            } else {
                print("CIDetectorTypeQRCode is Empty")
            }
        }
    }
    
    private func printResults(withResults results: NSArray) {
        /*
        for r in results {
            if let face = r as? CIFaceFeature {
                NSLog("Face found at (%f,%f) of dimensions %fx%f", face.bounds.origin.x, face.bounds.origin.y, face.bounds.width, face.bounds.height);
            }
            
            if let qr = r as? CIQRCodeFeature {
                print("QR Code Found: \(qr.messageString) at \(qr.bounds.origin.x)x\(qr.bounds.origin.y) with Size: \(qr.bounds.width)x\(qr.bounds.height)")
            }
        }
         */
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print("CameraFrameExtractor Ref Count: \(CFGetRetainCount(self.cameraFrameExtractor))")
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cameraFrameExtractor.stopSession()
        if(!self.detected) {
            self.evrythngScannerDelegate?.didCancelScan(viewController: self)
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Public Methods
    
    public func reset() {
        self.detected = false
    }
    
    deinit {
        print("\(#function) EvrythngScannerVC")
    }

}

extension EvrythngScannerVC: EvrythngCameraFrameExtractorDelegate {
    
    func capturedFromAVMetadataObject(value: String, ofType: String) {
        print("Captured Value: \(value) ofType: \(ofType) Delegate: \(self.evrythngScannerDelegate != nil)")
        self.detected = true
        self.evrythngScannerDelegate?.didFinishScan(viewController: self, value: value, format: nil, error: nil)
    }
    
    func captured(image: UIImage, asCIImage ciImage: CIImage, of value: String, of feature: GMVFeature?) {
        //print("Captured Image: \(uiImage) Delegate: \(self.evrythngScannerDelegate != nil)")
        self.imageView.image = image
        
        //self.scanImage(ciImage: ciImage)
        if(!StringUtils.isStringEmpty(string: value)) {
            if(!self.detected) {
                self.detected = true
                self.evrythngScannerDelegate?.didFinishScan(viewController: self, value: value, format: self.getDetectionFormat(from: feature), error: nil)
            }
        }
    }
    
    func willStartCapture() {
        self.evrythngScannerDelegate?.willStartScan(viewController: self)
    }
}

extension EvrythngScannerVC {
    
    internal func getDetectionFormat(from gmvFeature: GMVFeature?) -> GMVDetectorBarcodeFormat? {
        if case let barcodeFeature as GMVBarcodeFeature = gmvFeature {
            return barcodeFeature.format
        }
        return nil
    }
}
