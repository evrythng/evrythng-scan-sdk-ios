//
//  EvrythngNetworkError.swift
//  EvrythngiOS
//
//  Created by JD Castro on 24/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public enum EvrythngNetworkError: Error {

    case ResponseError(response: EvrythngNetworkErrorResponse)
    
    public var localizedDescription: String {
        switch(self) {
            case .ResponseError(let errorResponse):
                if let errorResponseRawStr = errorResponse.jsonData?.rawString() {
                    return errorResponseRawStr
                } else {
                    return "Unable to parse EvrythngNetworkErrorResponse"
                }
        }
    }
}
