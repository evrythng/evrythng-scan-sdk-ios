//
//  EvrythngError.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public enum EvrythngError: Error {
    case InvalidAppToken
    case InvalidUsernamePassword
    case NoDetectedBarcode
}

extension EvrythngError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .InvalidAppToken:
            return NSLocalizedString("Please check your App Token", comment: "")
        case .InvalidUsernamePassword:
            return NSLocalizedString("Invalid Username and/or Password", comment: "")
        case .NoDetectedBarcode:
            return NSLocalizedString("No Detected Barcode", comment: "")
        }
    }
}
