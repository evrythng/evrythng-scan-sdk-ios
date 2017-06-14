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
    internal var detector: GMVDetector!
    var cameraFrameExtractor: EvrythngCameraFrameExtractor!
    var detected = false
    
    // MARK: - Public Variables
    
    // We do not declare as `weak` reference type because the implementing ViewController
    // which declares / holds the EvrythngScanner instance will hold EvrthngScanner's instance.
    // Hence, this delegate should be manually set to nil to avoid memory leak
    var evrythngScannerDelegate: EvrythngScannerDelegate?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var croppedImageView: UIImageView!
    @IBOutlet weak var tempImgView: UIImageView!
    @IBOutlet weak var maskedForegroundView: UIView!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var cameraParentView: UIView!
    
    // MARK: - IBActions
    
    @IBAction func actionBack(_ sender: UIButton) {
        if let navVC = self.navigationController {
            if(navVC.childViewControllers.count == 0) {
                navVC.dismiss(animated: true, completion: nil)
            } else {
                navVC.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - View Controller Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EvrythngScanner"
        self.detector = GMVDetector(ofType: GMVDetectorTypeBarcode, options: nil)
        
        self.cameraFrameExtractor = EvrythngCameraFrameExtractor()
        self.cameraFrameExtractor.delegate = self
        
        self.detected = false;
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(EvrythngScannerVC.back(sender:)))
        self.navigationController?.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
    
    func getScaleBetween(size: CGSize, and size2: CGSize) -> CGFloat {
        let numerator = size.height * size.width
        let denominator = size2.height * size2.width
        
        return numerator / denominator
    }
    
    func captured(image: UIImage, asCIImage ciImage: CIImage) {
        //self.scanImage(ciImage: ciImage)
        self.displayAndDetect(uiImage: image)
    }
    
    func willStartCapture() {
        self.evrythngScannerDelegate?.willStartScan(viewController: self)
    }
    
    func displayAndDetect(uiImage: UIImage) {
        
        //let xScale = self.view.frame.size.width / uiImage.size.width
        let yScale = self.view.frame.size.height / (uiImage.size.height * uiImage.scale)
        
        let capturedFrame = CGRect(x: self.maskedForegroundView.frame.origin.x * yScale, y: self.maskedForegroundView.frame.origin.y / yScale, width: self.maskedForegroundView.frame.size.width / yScale , height: self.maskedForegroundView.frame.size.height / yScale)
        
        //print("Captured: \(String(describing:capturedFrame)) Image Size: \(String(describing:uiImage.size))")
        //print("Orig Frame: \(String(describing:self.maskedForegroundView.frame)) Parent: \(String(describing:self.view.frame))")
        
        let croppedImage = uiImage.crop(rect: capturedFrame)
        DispatchQueue.main.sync {
            self.imageView.image = uiImage
            self.croppedImageView.image = uiImage
            self.tempImgView.image = croppedImage
        }
        
        if let barcodeFeatures:[GMVBarcodeFeature] = self.detector.features(in: croppedImage, options: nil) as? [GMVBarcodeFeature] {
            
            let barcodeFeature = barcodeFeatures.last
            var barcodeRawValue = ""
            
            if (barcodeFeature != nil) {
                let barcodeFormat = barcodeFeature!.format as GMVDetectorBarcodeFormat
                barcodeRawValue = (barcodeFeature!.rawValue ?? "")!
                
                print("Detected \(barcodeFeatures.count) barcode(s) with Value: \(barcodeRawValue) Format: \(barcodeFormat)")
            } else {
                //print ("No Detected Barcodes")
            }
            
            DispatchQueue.main.sync {
                if(!StringUtils.isStringEmpty(string: barcodeRawValue)) {
                    if(!self.detected) {
                        self.detected = true
                        self.evrythngScannerDelegate?.didFinishScan(viewController: self, value: barcodeRawValue, format: self.getDetectionFormat(from: barcodeFeature), error: nil)
                    }
                }
            }
            
        } else {
            print("Unable to extract features from image")
        }
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
