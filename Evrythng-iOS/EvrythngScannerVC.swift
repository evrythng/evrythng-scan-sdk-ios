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
        
//        let testView = UIView(frame: CGRect(x:0,y:0,width:100,height:100))
//        testView.layer.borderWidth = 2
//        testView.layer.borderColor = UIColor.green.cgColor
//        self.cameraParentView.addSubview(testView)
        
        self.detected = false
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
    
    func scaleBetween(rect1: CGRect, and rect2: CGRect) -> CGSize {
        var size = CGSize.zero
        
        let rect1Height = rect1.size.height
        let rect1Width = rect1.size.width
        
        let rect2Height = rect2.size.height
        let rect2Width = rect2.size.width
        
        size = CGSize(width: rect1Width / rect2Width, height: rect1Height / rect2Height)
        
        print("Scale Between 2 Rects: \(String(describing:size))")
        
        return size
    }
    
    func getCroppedRect(imageView: UIImageView, parent parentFrame: CGRect, target targetCropFrame: CGRect) -> CGRect {
        
        var croppedRect = CGRect(x:0,y:0,width:0,height:0)
        
        if let imageSize = imageView.image?.size {
            let imageViewScale = imageView.imageScale
            let imageViewScaleWidth = imageViewScale.width
            let imageViewScaleHeight = imageViewScale.height
            
            let actualRenderedImageWidth = imageSize.width * imageViewScaleWidth
            let actualRenderedImageHeight = imageSize.height * imageViewScaleHeight
            let actualRenderedImageSize = CGSize(width: actualRenderedImageWidth, height: actualRenderedImageHeight)
            
            print("Image Size :\(String(describing:imageSize))) ImageView Scale: \(String(describing:imageViewScale)) Scaled Size: \(String(describing:actualRenderedImageSize))")
            
            // This is the exact rect containing the Aspect Fill Image
            let aspectFillImageRect = CGRect(x:0, y:0, width: actualRenderedImageWidth, height: actualRenderedImageHeight)
            let scaleBetweenRect = self.scaleBetween(rect1: aspectFillImageRect, and: parentFrame)
            let scaleBetweenRectWidth = scaleBetweenRect.width
            let scaleBetweenRectHeight = scaleBetweenRect.height
            
            print("Parent Container: \(String(describing:parentFrame)) AspectFill Image Size :\(String(describing:aspectFillImageRect.size)))")
            
            print("Scale Between Parent Frame and Aspect Fill Image: \(String(describing:scaleBetweenRect))")
            
            let diffWidthBetweenRect = (aspectFillImageRect.size.width - parentFrame.size.width) / 2
            let diffHeightBetweenRect = (aspectFillImageRect.size.height - parentFrame.size.height) / 2
            let scaledDiffWidth = diffWidthBetweenRect / imageViewScaleWidth
            let scaledDiffHeight = diffHeightBetweenRect / imageViewScaleHeight
            
            print("Diff Between Parent Frame and Aspect Fill Image Width: \(diffWidthBetweenRect)  Height: \(diffHeightBetweenRect) Scaled Width: \(scaledDiffWidth) Scaled Height: \(scaledDiffHeight)")
            
            let translatedX = ((targetCropFrame.origin.x * scaleBetweenRectWidth) + scaledDiffWidth) / imageViewScaleWidth
            let translatedY = ((targetCropFrame.origin.y * scaleBetweenRectHeight) + scaledDiffHeight) / imageViewScaleHeight
            let translatedWidth = targetCropFrame.size.width / imageViewScaleWidth
            let translatedHeight = ((targetCropFrame.size.height / scaleBetweenRectHeight) - scaledDiffHeight) / imageViewScaleHeight
            
            let translatedRect = CGRect(x: translatedX, y:translatedY, width: translatedWidth, height: translatedHeight)
            
            croppedRect = translatedRect
            
            print("Translated Cropped Rect :\(String(describing:croppedRect)) from : \(String(describing:aspectFillImageRect))")
        } else {
            print("Unable to crop rect")
        }
        return croppedRect
    }
    
    func displayAndDetect(uiImage: UIImage) {
       
        let cropRect = self.getCroppedRect(imageView: self.imageView, parent: self.cameraParentView.frame, target: self.maskedForegroundView.frame)

        print("Crop: \(String(describing:cropRect))")
        let croppedImage = uiImage.crop(rect: cropRect)
        
        DispatchQueue.main.sync {
            self.imageView.image = uiImage
            self.croppedImageView.image = uiImage
            self.tempImgView.image = croppedImage
            
            print("Scale Factor: \(self.imageView.contentScaleFactor)")
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
    
    func getCropAreaRect(cropRect: CGRect, image: UIImage) -> CGRect {
        var rect = CGRect(x:0,y:0,width:0,height:0)
        
        return rect
    }
    
    func getAspectFillSize(aspectRatio: CGSize, minSize: CGSize) -> CGSize {
        var aspectFillSize:CGSize = CGSize(width: minSize.width, height:minSize.height);
        let mW = minSize.width / aspectRatio.width;
        let mH = minSize.height / aspectRatio.height;
        if(mH > mW) {
            aspectFillSize.width = mH * aspectRatio.width;
        }
        else if(mW > mH) {
            aspectFillSize.height = mW * aspectRatio.height;
        }
        return aspectFillSize;
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
//    func scaleImageToSize(newSize: CGSize, containerSize: CGSize) -> UIImage {
//        var scaledImageRect = CGRect.zero
//        
//        let aspectWidth = newSize.width/containerSize.width
//        let aspectheight = newSize.height/containerSize.height
//        
//        let aspectRatio = max(aspectWidth, aspectheight)
//        
//        scaledImageRect.size.width = containerSize.width * aspectRatio;
//        scaledImageRect.size.height = containerSize.height * aspectRatio;
//        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
//        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
//        
//        UIGraphicsBeginImageContext(newSize)
//        draw(in: scaledImageRect)
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return scaledImage!
//    }
}

extension EvrythngScannerVC {
    
    internal func getDetectionFormat(from gmvFeature: GMVFeature?) -> GMVDetectorBarcodeFormat? {
        if case let barcodeFeature as GMVBarcodeFeature = gmvFeature {
            return barcodeFeature.format
        }
        return nil
    }
}

extension UIImageView {
    var imageScale: CGSize {
        
        if let image = self.image {
            let sx = Double(self.frame.size.width / image.size.width)
            let sy = Double(self.frame.size.height / image.size.height)
            var s = 1.0
            switch (self.contentMode) {
            case .scaleAspectFit:
                s = fmin(sx, sy)
                return CGSize (width: s, height: s)
                
            case .scaleAspectFill:
                s = fmax(sx, sy)
                return CGSize(width:s, height:s)
                
            case .scaleToFill:
                return CGSize(width:sx, height:sy)
                
            default:
                return CGSize(width:s, height:s)
            }
        }
        
        return CGSize.zero
    }
}
