//
//  EvrythngScanIdentificationsResponse.swift
//  EvrythngiOS
//
//  Created by JD Castro on 29/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

import Moya_SwiftyJSONMapper
import SwiftyJSON

public final class EvrythngScanIdentificationsResponse: ALSwiftyJSONAble {
    
    public var jsonData: JSON?
    
    public var results: [IdentificationResult]?
    public var meta: Meta?
    
    public init?(jsonData: JSON) {
        
        self.jsonData = jsonData
        if let temp_results = jsonData.array?.first {
            if let resultsArr = temp_results["results"].array {
                self.results = [IdentificationResult]()
                for dic in resultsArr {
                    self.results?.append(IdentificationResult(jsonData: dic)!)
                }
            }
            print("Init Results: \(self.results)")
            self.meta = Meta(jsonData: jsonData["meta"])
        }
    }
}
