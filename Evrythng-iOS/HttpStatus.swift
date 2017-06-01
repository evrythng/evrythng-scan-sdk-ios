//
//  HttpStatus.swift
//  EvrythngiOS
//
//  Created by JD Castro on 15/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public enum HttpStatus: Int {
    
    case OK = 200
    case CREATED = 201
    case ACCEPTED = 202
    case NO_CONTENT = 204
    case MOVED_PERMANENTLY = 301
    case TEMPORARY_REDIRECT = 307
    case BAD_REQUEST = 400
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    case METHOD_NOT_ALLOWED = 405
    case NOT_ACCEPTABLE = 406
    case CONFLICT = 409
    case REQUEST_ENTITY_TOO_LARGE = 413
    case TOO_MANY_REQUESTS = 429
    case INTERNAL_SERVER_ERROR = 500
    case SERVICE_UNAVAILABLE = 503

    func getFamily() -> Family {
        switch(self.rawValue / 100) {
            case 1:
                return .INFORMATIONAL
            case 2:
                return .SUCCESSFUL
            case 3:
                return .REDIRECTION
            case 4:
                return .CLIENT_ERROR
            case 5:
                return .SERVER_ERROR
            default:
                return .OTHER
        }
    }
    
    func getReasonPhrase() -> String {
        switch(self) {
            case .OK:
                return "OK"
            case .CREATED:
                return "Created"
            case .ACCEPTED:
                return "Accepted"
            case .NO_CONTENT:
                return "No Content"
            case .MOVED_PERMANENTLY:
                return "Moved Permamently"
            case .TEMPORARY_REDIRECT:
                return "Temporary Redirect"
            case .BAD_REQUEST:
                return "Bad Request"
            case .UNAUTHORIZED:
                return "Unauthorized"
            case .FORBIDDEN:
                return "Forbidden"
            case .NOT_FOUND:
                return "Not Found"
            case .METHOD_NOT_ALLOWED:
                return "Method Not Allowed"
            case .NOT_ACCEPTABLE:
                return "Not Acceptable"
            case .CONFLICT:
                return "Conflict"
            case .REQUEST_ENTITY_TOO_LARGE:
                return "Request Entity Too Large"
            case .TOO_MANY_REQUESTS:
                return "Too Many Requests"
            case .INTERNAL_SERVER_ERROR:
                return "Internal Server Error"
            case .SERVICE_UNAVAILABLE:
                return "Service Unavailable"
        }
    }
}

public enum Family {
    case INFORMATIONAL, SUCCESSFUL, REDIRECTION, CLIENT_ERROR, SERVER_ERROR, OTHER
}
