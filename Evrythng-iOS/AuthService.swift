//
//  AuthService.swift
//  EvrythngiOS
//
//  Created by JD Castro on 16/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class AuthService: EvrythngService {
    public func evrythngUserCreator(user: User?) -> EvrythngUserCreator {
        let userCreator = EvrythngUserCreator(user: user)
        userCreator.apiKey = self.apiKey
        return userCreator
    }
    
    public func evrythngOperator(operatorApiKey: String) -> EvrythngOperator {
        let evtOperator = EvrythngOperator(operatorApiKey: operatorApiKey)
        evtOperator.apiKey = self.apiKey
        return evtOperator
    }
    
    public func evrythngUserValidator(userId: String, activationCode: String) -> EvrythngUserValidator {
        let evtUserValidator = EvrythngUserValidator(userId: userId, activationCode: activationCode)
        evtUserValidator.apiKey = self.apiKey
        return evtUserValidator
    }
    
    public func evrythngUserLogouter(apiKey: String) -> EvrythngUserLogouter {
        let evtUserLogouter = EvrythngUserLogouter(apiKey: apiKey)
        evtUserLogouter.apiKey = self.apiKey
        return evtUserLogouter
    }
    
    public func evrythngUserAuthenticator(email: String, password: String) -> EvrythngUserAuthenticator {
        let evtUserAuthenticator = EvrythngUserAuthenticator(email: email, password: password)
        evtUserAuthenticator.apiKey = self.apiKey
        return evtUserAuthenticator
    }
}
