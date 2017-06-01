//
//  UserDefaultsUtils.swift
//  EvrythngiOS
//
//  Created by JD Castro on 10/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class UserDefaultsUtils {
    
    public static func clearUserDefaults() {
        
        let userDefaults:UserDefaults = UserDefaults.standard
        
        //Put here keys that should be cleared
        
        userDefaults.synchronize()
    }
    
    public static func save(key: String, value: AnyObject) {
        let userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    public static func get(key: String) -> AnyObject? {
        let userDefaults:UserDefaults = UserDefaults.standard
        let fetchedResult:AnyObject? = userDefaults.object(forKey: key) as AnyObject?
        return fetchedResult
    }
    

}
