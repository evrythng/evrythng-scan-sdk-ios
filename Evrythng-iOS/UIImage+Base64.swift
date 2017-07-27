//
//  UIImage+Base64.swift
//  EvrythngiOS
//
//  Created by Princess on 7/27/17.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

extension UIImage {
    
    func toBase64() -> String? {
        let imageData = UIImagePNGRepresentation(self)
        return imageData?.base64EncodedString()
    }
}
