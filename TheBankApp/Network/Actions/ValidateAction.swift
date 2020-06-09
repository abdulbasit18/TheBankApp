//
//  ValidateBicAction.swift
//  TheBankApp
//
//  Created by Abdul Basit on 29/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Alamofire

enum ValidateAction: APIAction {
    case validateBic(value: String?)
    case validateIban(value: String?)
    case validatePostCode(countryCode: String?, postCode: String?)
    
    var method: HTTPMethod {
            return .get
    }
    
    var path: String {
        switch self {
        case .validateBic:
            return "/validateBic"
        case .validateIban:
            return "/validateIban"
        case .validatePostCode:
            return "/validatePostCode"
        }
        
    }
    var encoding: ParameterEncoding {
            return URLEncoding.default
    }
    
    var actionParameters: [String: String] {
        switch self {
        case let .validateBic(bic):
            return["bic": bic ?? ""]
        case let .validateIban(iban):
            return ["iban": iban ?? ""]
        case let .validatePostCode(countryCode, postCode):
            return ["countryCode": countryCode ?? "",
                    "postCode": postCode ?? ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
            let originalRequest = try URLRequest(url: baseURL.appending(path),
                                                 method: method,
                                                 headers: authHeader)
            
            let encodedRequest = try encoding.encode(originalRequest,
                                                     with: actionParameters)
            return encodedRequest
    }
}
