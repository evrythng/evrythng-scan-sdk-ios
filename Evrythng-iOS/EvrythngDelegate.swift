//
//  EvrythngDelegate.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public protocol EvrythngDelegate {
    func evrythngInitializationDidSucceed() -> Void
    func evrythngInitializationDidFail() -> Void
}
