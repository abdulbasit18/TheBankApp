//
//  SearchBicAction.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Alamofire

enum SearchBicAction: APIAction {
    
    case search(page: String?, search: FilterModel?)
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/searchBic"
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var actionParameters: [String: String] {
        switch self {
        case let .search(page, search):
            let params = ["page": page ?? "",
                          "location": search?.location ?? "",
                          "bankname": search?.bank ?? "",
                          "blz": search?.blz ?? "",
                          "countryCode": search?.countryCode ?? ""
                
            ]
            
            return params
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
