//
//  EvrythngScannerError.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public enum EvrythngScannerError: Error {
    case NotConformingToEvrthngScannerProtocol
}

extension EvrythngScannerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NotConformingToEvrthngScannerProtocol:
            return NSLocalizedString("Please conform to EvrythngScannerProtocol", comment: "")
        }
    }
}
