//
//  URLHelper.swift
//  EvrythngiOS
//
//  Created by JD Castro on 27/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class URLHelper {

    /**
     Add, update, or remove a query string item from the URL
     
     :param: url   the URL
     :param: key   the key of the query string item
     :param: value the value to replace the query string item, nil will remove item
     
     :returns: the URL with the mutated query string
     */
    public class func addOrUpdateQueryStringParameter(url: String, key: String, value: Any?) -> String {
        if var components = URLComponents(string: url) {
            
            if var queryItems = components.queryItems {
                for (index, item) in queryItems.enumerated() {
                    // Match query string key and update
                    if item.name == key {
                        if let v = value {
                            queryItems[index] = URLQueryItem(name: key, value: v as? String)
                        } else {
                            queryItems.remove(at: index)
                        }
                        components.queryItems = queryItems.count > 0
                            ? queryItems : nil
                        return components.string!
                    }
                }
                
                // Key doesn't exist if reaches here
                if let v = value {
                    // Add key to URL query string
                    queryItems.append(URLQueryItem(name: key, value: v as? String))
                    components.queryItems = queryItems as [URLQueryItem]
                    return components.string!
                }
            } else {
                
                if let v = value {
                    // Add key to URL query string
                    components.queryItems = [URLQueryItem(name: key, value: v as? String)]
                    return components.string!
                }
                
            }
        }
        
        return url
    }
    
    /**
     Add, update, or remove a query string parameters from the URL
     
     :param: url   the URL
     :param: values the dictionary of query string parameters to replace
     
     :returns: the URL with the mutated query string
     */
    public class func addOrUpdateQueryStringParameter(url: String, values: [String: Any]) -> String {
        var newUrl = url
        
        for item in values {
            newUrl = addOrUpdateQueryStringParameter(url: newUrl, key: item.0, value: item.1)
        }
        
        return newUrl
    }
    
    /**
     Removes a query string item from the URL
     
     :param: url   the URL
     :param: key   the key of the query string item
     
     :returns: the URL with the mutated query string
     */
    public class func removeQueryStringParameter(url: String, key: String) -> String {
        return addOrUpdateQueryStringParameter(url: url, key: key, value: nil)
    }
    
}
