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
    
    //private
    private var _jsonData: JSON?
    private var _results: [IdentificationResult]?
    private var _meta: Meta?
    
    //public
    public var jsonData: JSON? {return _jsonData}
    public var results: [IdentificationResult]? {return _results}
    public var meta: Meta? {return _meta}
    
    public init?(jsonData: JSON) {
        
        self._jsonData = jsonData
        if let temp_results = jsonData.array?.first {
            if let resultsArr = temp_results["results"].array {
                self._results = [IdentificationResult]()
                for dic in resultsArr {
                    self._results?.append(IdentificationResult(jsonData: dic)!)
                }
            }
            //print("Init Results: \(String(describing: self.results))")
            self._meta = Meta(jsonData: jsonData["meta"])
        }
    }
}
