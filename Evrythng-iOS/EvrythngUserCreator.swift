
//
//  EvrythngUserCreator.swift
//  EvrythngiOS
//
//  Created by JD Castro on 12/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import Moya
import MoyaSugar
import Moya_SwiftyJSONMapper
import Alamofire

public class EvrythngUserCreator: EvrythngNetworkExecutableProtocol {
    
    private var user: User?
    private var credentials: Credentials!
    
    private init() {
    
    }
    
    internal init(user: User?) {
        self.user = user
    }
    
    internal init(credentials: Credentials) {
        self.credentials = credentials
    }
    
    public func getDefaultProvider() -> EvrythngMoyaProvider<EvrythngNetworkService> {
        
        let epClosure = { (target: EvrythngNetworkService) -> Endpoint<EvrythngNetworkService> in
            
            
            if case is CompositeEncoding = target.params?.encoding  {
                if let params = target.params?.values["query"] {
                    print("\(target.defaultURL.absoluteString)")
                    let url = URLHelper.addOrUpdateQueryStringParameter(url: target.defaultURL.absoluteString, values: params as! [String : String])
                    
                    let test = Endpoint<EvrythngNetworkService>(url: url, sampleResponseClosure: {
                        return EndpointSampleResponse.networkResponse(200, target.sampleData)
                    }, method: .post, parameters: target.params?.values, parameterEncoding: (target.params?.encoding)!, httpHeaderFields: target.httpHeaderFields)
                    
                    print("Absolute Url: \(test.url)")
                    return test
                }
            }
            
            return Endpoint<EvrythngNetworkService>(url: target.url.absoluteString, sampleResponseClosure: target.sampleResponseClosure, method: target.method, parameters: target.params?.values, parameterEncoding: target.params!.encoding, httpHeaderFields: target.httpHeaderFields)
        }
        
        return EvrythngMoyaProvider<EvrythngNetworkService>(endpointClosure: epClosure)
    }
    
    public func execute(completionHandler: @escaping (Credentials?, Swift.Error?) -> Void) {
        
        let userRepo = EvrythngNetworkService.createUser(user: self.user, isAnonymous: (self.user == nil))
        //let provider = MoyaSugarProvider<EvrythngNetworkService>()
        
        self.getDefaultProvider().request(userRepo) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("Data: \(datastring!) Status Code: \(statusCode)")
                
                if(200..<300 ~= statusCode) {
                    do {
                        let credentials = try moyaResponse.map(to: Credentials.self)
                        completionHandler(credentials, nil)
                    } catch {
                        print(error)
                        completionHandler(nil, error)
                    }
                } else {
                    do {
                        let err = try moyaResponse.map(to: EvrythngNetworkErrorResponse.self)
                        print("EvrythngNetworkErrorResponse: \(err.jsonData?.rawString())")
                        completionHandler(nil, EvrythngNetworkError.ResponseError(response: err))
                    } catch {
                        print(error)
                        completionHandler(nil, error)
                    }
                }
                
            case let .failure(error):
                print("Error: \(error)")
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
                completionHandler(nil, error)
                break
            }
        }
    }
}
