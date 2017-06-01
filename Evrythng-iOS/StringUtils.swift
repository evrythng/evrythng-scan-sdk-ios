//
//  StringUtils.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public final class StringUtils {
    
    public static func isStringEmpty(string: String?) -> Bool {
        if let string = string, !string.isEmpty {
            return false
        }
        return true
    }
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
