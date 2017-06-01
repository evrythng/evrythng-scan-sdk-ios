//
//  EvrythngNetworkServiceError.swift
//  EvrythngiOS
//
//  Created by JD Castro on 10/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public enum EvrythngNetworkServiceError: Error {
    case responseParseException
    case dataParseException(source: String)
    case mappableParseException
    case userDeletionFailedException
}
