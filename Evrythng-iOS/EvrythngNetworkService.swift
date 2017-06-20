//
//  EvrythngNetworkService.swift
//  EvrythngiOS
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import Foundation

import Moya
import MoyaSugar

public enum EvrythngNetworkService {
    case url(String)
    
    // User
    case createUser(apiKey: String?, user: User?)
    case deleteUser(operatorApiKey: String, userId: String)
    case authenticateUser(apiKey: String?, credentials: Credentials)
    case validateUser(apiKey: String?, userId: String, activationCode: String)
    case logout(apiKey: String)
    
    // Thng
    case readThng(apiKey: String?, thngId: String)
    
    // Scan
    case identify(scanType: EvrythngScanTypes, scanMethod: EvrythngScanMethods, value: String)
}

extension EvrythngNetworkService: EvrythngNetworkTargetType {
    
    public var sampleResponseClosure: (() -> EndpointSampleResponse) {
        return {
            return EndpointSampleResponse.networkResponse(200, self.sampleData)
        }
    }

    public var baseURL: URL { return URL(string: "https://api.evrythng.com")! }
    //public var baseURL: URL { return URL(string: "https://www.jsonblob.com/api")! }
    
    /// method + path
    public var route: Route {
        switch self {
        case .url(let urlString):
            return .get(urlString)
        case .createUser:
            return .post("/auth/evrythng/users")
        case .deleteUser(_, let userId):
            return .delete("/users/\(userId)")
        case .authenticateUser:
            return .post("/auth/evrythng")
        case .validateUser(_, let userId, _):
            let path = "auth/evrythng/users/\(userId)/validate"
            return .post(path)
        case .logout:
            return .post("/auth/all/logout")
            
        case .readThng(_, let thngId):
            return .get("/thngs/\(thngId)")
        case .identify:
            return .get("/scan/identifications")
        }
    }
    
    // override default url building behavior
    public var url: URL {
        switch self {
        case .url(let urlString):
            return URL(string: urlString)!
        default:
            return self.defaultURL
        }
    }
    
    /// encoding + parameters
    public var params: Parameters? {
        switch self {
        case .createUser(_, let user):
            if(user != nil) {
                //print("Test: \(String(describing: user!.jsonData!.dictionaryObject))")
                return JSONEncoding() => user!.jsonData!.dictionaryObject!
            } else {
                var params:[String: Any] = [:]
                params[EvrythngNetworkServiceConstants.REQUEST_URL_PARAMETER_KEY] = ["anonymous": "true"]
                params[EvrythngNetworkServiceConstants.REQUEST_BODY_PARAMETER_KEY] = [:]
                return CompositeEncoding() => params
            }
            /*
            if(anonymous == true) {
                var params:[String: Any] = [:]
                params[EvrythngNetworkServiceConstants.REQUEST_URL_PARAMETER_KEY] = ["anonymous": "true"]
                params[EvrythngNetworkServiceConstants.REQUEST_BODY_PARAMETER_KEY] = [:]
                return CompositeEncoding() => params
            } else {
                return JSONEncoding() => user!.jsonData!.dictionaryObject!
            }
             */
        case .validateUser(_, _, let activationCode):
            return JSONEncoding() => ["activationCode": activationCode]
        case .authenticateUser(_, let credentials):
            return JSONEncoding() => ["email": credentials.email!, "password": credentials.password!]
        case .logout:
            return JSONEncoding() => [:]
            
        case .identify(let scanType, _, let value):
            let urlEncodedFilter = "type=\(scanType.rawValue)&value=\(value)"
            let encoding = URLEncoding() => ["filter": urlEncodedFilter]
            if(Evrythng.DEBUGGING_ENABLED) {
                print("Encoding: \(encoding.values.description)")
            }
            return encoding
            
        default:
            return JSONEncoding() => [:]
        }
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return "{}".utf8Encoded
        }
    }
    
    public var httpHeaderFields: [String: String]? {
        var headers: [String:String] = [:]
        
        headers[EvrythngNetworkServiceConstants.HTTP_HEADER_ACCEPTS] = "application/json"
        headers[EvrythngNetworkServiceConstants.HTTP_HEADER_CONTENT_TYPE] = "application/json"
        
        var authorization: String?
        switch(self) {
        case .createUser(let apiKey, _):
            authorization = apiKey
        case .authenticateUser(let apiKey, _):
            authorization = apiKey
        case .validateUser(let apiKey, _, _):
            authorization = apiKey
            
        // Thng
        case .readThng(let apiKey, _):
            authorization = apiKey
        case .logout(let apiKey):
            authorization = apiKey
        case .deleteUser(let operatorApiKey, _):
            // Sample Operator API Key
            //authorization = "hohzaKH7VbVp659Pnr5m3xg2DpKBivg9rFh6PttT5AnBtEn3s17B8OPAOpBjNTWdoRlosLTxJmUrpjTi"
            authorization = operatorApiKey
        default:
            // Get from NSUserDefaults instead
            authorization = UserDefaultsUtils.get(key: Constants.CachedAppToken) as? String
        }
        
        if let auth = authorization, !auth.isEmpty {
            headers[EvrythngNetworkServiceConstants.HTTP_HEADER_AUTHORIZATION] = auth
        } else {
            if let cachedApiKey = UserDefaultsUtils.get(key: Constants.CachedAppToken) as? String {
                headers[EvrythngNetworkServiceConstants.HTTP_HEADER_AUTHORIZATION] = cachedApiKey
            }
        }
        
        if(Evrythng.DEBUGGING_ENABLED) {
            print("Headers: \(headers)")
        }
        return headers
    }
    
    public var task: Task {
        switch self {
        case .createUser, .url:
            fallthrough
        default:
            return .request
        }
    }
}

internal struct EvrythngNetworkServiceConstants {
    static let AppToken = "evrythng_app_token"
    
    static let EVRYTHNG_OPERATOR_API_KEY = "evrythng_operator_api_key"
    static let EVRYTHNG_APP_API_KEY = "evrythng_app_api_key"
    static let EVRYTHNG_APP_USER_API_KEY = "evrythng_app_user_api_key"
    
    static let HTTP_HEADER_AUTHORIZATION = "Authorization"
    static let HTTP_HEADER_ACCEPTS = "Accept"
    static let HTTP_HEADER_CONTENT_TYPE = "Content-Type"
    
    static let REQUEST_URL_PARAMETER_KEY = "query"
    static let REQUEST_BODY_PARAMETER_KEY = "body"
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
