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
    case createUser(user: User?, isAnonymous: Bool)
    case deleteUser(operatorApiKey: String, userId: String)
    case authenticateUser(credentials: Credentials)
    case validateUser(userId: String, activationCode: String)
    case logout(apiKey: String)
    
    case editIssue(owner: String, repo: String, number: Int, title: String?, body: String?)
    
    // Thng
    case readThng(thngId: String)
    
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
        case .validateUser(let userId, _):
            return .post("/users/\(userId)/validate")
        case .logout:
            return .post("/auth/all/logout")
        case .editIssue(let owner, let repo, let number, _, _):
            return .patch("/repos/\(owner)/\(repo)/issues/\(number)")
            
        case .readThng(let thngId):
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
        case .createUser(let user, let anonymous):
            if(anonymous == true) {
                var params:[String: Any] = [:]
                params[EvrythngNetworkServiceConstants.REQUEST_URL_PARAMETER_KEY] = ["anonymous": "true"]
                params[EvrythngNetworkServiceConstants.REQUEST_BODY_PARAMETER_KEY] = [:]
                return CompositeEncoding() => params
            } else {
                return JSONEncoding() => user!.jsonData!.dictionaryObject!
            }
            /*
            [
                "firstName": "Test First1", "lastName": "Test Last1", "email": "validemail1@email.com", "password": "testPassword1"
            ]
            */
        case .validateUser(_, let activationCode):
            return JSONEncoding() => ["activationCode": activationCode]
        case .authenticateUser(let credentials):
            return JSONEncoding() => ["email": credentials.email!, "password": credentials.password!]
        case .logout:
            return JSONEncoding() => [:]
            
        case .identify(let scanType, let scanMethod, let value):
            let urlEncodedFilter = "type=\(scanType.rawValue)&value=\(value)"
            let encoding = URLEncoding() => ["filter": urlEncodedFilter]
            print("Encoding: \(encoding.values.description)")
            return encoding
            
        case .editIssue(_, _, _, let title, let body):
            // Use `URLEncoding()` as default when not specified
            return [
                "title": title,
                "body": body,
            ]
            
        default:
            return JSONEncoding() => [:]
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .editIssue(_, let owner, _, _, _):
            return "{\"id\": 100, \"owner\": \"\(owner)}".utf8Encoded
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
        case .deleteUser(let operatorApiKey, _):
            // Operator API Key
            //authorization = "hohzaKH7VbVp659Pnr5m3xg2DpKBivg9rFh6PttT5AnBtEn3s17B8OPAOpBjNTWdoRlosLTxJmUrpjTi"
            authorization = operatorApiKey
        case .logout(let apiKey):
            authorization = apiKey
        default:
            authorization = UserDefaultsUtils.get(key: "pref_key_authorization") as? String
            if let authorization = UserDefaultsUtils.get(key: "pref_key_authorization") as? String{
                headers[EvrythngNetworkServiceConstants.HTTP_HEADER_AUTHORIZATION] = authorization
            }
        }
        
        if let auth = authorization {
            if(!auth.isEmpty) {
                headers[EvrythngNetworkServiceConstants.HTTP_HEADER_AUTHORIZATION] = auth
            }
        }
        
        print("Headers: \(headers)")
        return headers
    }
    
    public var task: Task {
        switch self {
        case .editIssue, .createUser, .url:
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
