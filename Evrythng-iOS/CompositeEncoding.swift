//
//  CompositeEncoding.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya
import Alamofire

struct CompositeEncoding: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else {
            return try urlRequest.asURLRequest()
        }
        
        let queryParameters = (parameters["query"] as! Parameters)
        let queryRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: queryParameters)
        
        if let body = parameters["body"] {
            let bodyParameters = (body as! Parameters)
            var bodyRequest = try JSONEncoding().encode(urlRequest, with: bodyParameters)
            
            bodyRequest.url = queryRequest.url
            return bodyRequest
        } else {
            return queryRequest
        }
    }
}
