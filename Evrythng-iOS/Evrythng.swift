//
//  Evrythng.swift
//  Evrythng-iOS
//
//  Created by JD Castro on 25/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class Evrythng {
    
    private static let TAG = "Evrythng"

    static var apiManager: EvrythngApiManager?
    
    // MARK: Private class vars
    
    private class var appToken: String? {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                if let dimension1 = NSDictionary(contentsOfFile: path) {
                    if let token = dimension1["evrythng_app_token"] as? String{
                        return token
                    }
                }
            }
            return nil
        }
    }
    
    // MARK: Public instance vars
    
    static var delegate: EvrythngDelegate?
    
    public class func initialize(delegate: EvrythngDelegate?) {
        self.delegate = delegate
        
        print("\(TAG) App Token: \(Evrythng.appToken)")
        
        if(StringUtils.isStringEmpty(string: self.appToken)) {
            self.delegate?.evrythngInitializationDidFail()
        } else {
            
            self.apiManager = EvrythngApiManager(apiKey: self.appToken!)
            
            // TODO: Authenticate in Evrythng API
            UserDefaultsUtils.save(key: "pref_key_authorization", value: self.appToken! as AnyObject)
            self.delegate?.evrythngInitializationDidSucceed()
        }
    }
    
    private init() {
    
    }
    
}
