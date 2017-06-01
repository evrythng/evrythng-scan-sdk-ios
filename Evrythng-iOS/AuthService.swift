//
//  AuthService.swift
//  EvrythngiOS
//
//  Created by JD Castro on 16/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class AuthService {
    public func evrythngUserCreator(user: User?) -> EvrythngUserCreator {
        return EvrythngUserCreator(user: user)
    }
    
    public func evrythngOperator(operatorApiKey: String) -> EvrythngOperator {
        return EvrythngOperator(operatorApiKey: operatorApiKey)
    }
    
    public func evrythngUserValidator(userId: String, activationCode: String) -> EvrythngUserValidator {
        return EvrythngUserValidator(userId: userId, activationCode: activationCode)
    }
    
    public func evrythngUserLogouter(apiKey: String) -> EvrythngUserLogouter {
        return EvrythngUserLogouter(apiKey: apiKey)
    }
    
    public func evrythngUserAuthenticator(email: String, password: String) -> EvrythngUserAuthenticator {
        return EvrythngUserAuthenticator(email: email, password: password)
    }
}
