//
//  UIImage+Base64.swift
//  EvrythngiOS
//
//  Created by Princess on 7/27/17.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func toBase64() -> String? {
        let imageData = UIImagePNGRepresentation(self)
        let base64String:String = (imageData?.base64EncodedString())!
        let fullBase64String:String = "data:image/png;base64," + base64String
        return fullBase64String
    }
}
