//
//  EvrythngMoyaProvider.swift
//  EvrythngiOS
//
//  Created by JD Castro on 15/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

import MoyaSugar
import Moya
import Moya_SwiftyJSONMapper

public class EvrythngMoyaProvider<Target>: MoyaSugarProvider<Target> where Target: EvrythngNetworkTargetType {
    
    public init() {
        let epClosure = { (target: Target) -> Endpoint<Target> in
            
            if case is CompositeEncoding = target.params?.encoding  {
                if let queryParams = target.params?.values[EvrythngNetworkServiceConstants.REQUEST_URL_PARAMETER_KEY] {
                    print("\(target.defaultURL.absoluteString)")
                    let url = URLHelper.addOrUpdateQueryStringParameter(url: target.defaultURL.absoluteString, values: queryParams as! [String : String])
                    
                    let test = Endpoint<Target>(url: url, sampleResponseClosure: {
                        return EndpointSampleResponse.networkResponse(200, target.sampleData)
                    }, method: .post, parameters: target.params?.values, parameterEncoding: (target.params?.encoding)!, httpHeaderFields: target.httpHeaderFields)
                    
                    print("Absolute Url: \(test.url)")
                    return test
                }
            }
            
            return Endpoint<Target>(url: target.url.absoluteString, sampleResponseClosure: target.sampleResponseClosure, method: target.method, parameters: target.params?.values, parameterEncoding: target.params!.encoding, httpHeaderFields: target.httpHeaderFields)
        }
        
        super.init(endpointClosure: epClosure)
    }
    
    public init(endpointClosure: @escaping (Target) -> Endpoint<Target>) {
        super.init(endpointClosure: endpointClosure)
    }
    
    public override init(endpointClosure: @escaping (Target) -> Endpoint<Target>, requestClosure: @escaping (Endpoint<Target>, @escaping MoyaSugarProvider<Target>.RequestResultClosure) -> Void, stubClosure: @escaping (Target) -> StubBehavior, manager: Manager, plugins: [PluginType], trackInflights: Bool) {
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: DefaultAlamofireManager.sharedManager, plugins: plugins)
    }
    
}
