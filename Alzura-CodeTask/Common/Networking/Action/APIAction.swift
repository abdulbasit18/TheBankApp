//
//  APIAction.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Alamofire

protocol APIAction: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var actionParameters: [String: String] { get }
    var baseURL: String { get }
    var authHeader: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
}

extension APIAction {
    var authHeader: HTTPHeaders {
        
        let user = "106901"
        let password = "NjQ3ZTFlMzY2Nzk1MDUwMzY1M2ExMTMwMzc0Y2YzOGY="
        let credentialData = "\(user):\(password)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString() ?? ""
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        return HTTPHeaders(headers)
    }
    var baseURL: String {
        return NetworkConfigurationConstants.baseUrl
    }
}
