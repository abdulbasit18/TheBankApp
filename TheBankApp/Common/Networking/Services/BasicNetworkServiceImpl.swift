//
//  BasicNetworkServiceImpl.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift
import RxAlamofire

protocol NetworkService {
    func load<T>(_ resource: SingleItemResource<T>) -> Observable<T>
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]>
}

struct BasicNetworkServiceImpl: NetworkService {
    
    func load<T>(_ resource: SingleItemResource<T>) -> Observable<T> where T: Codable {
        return
            RxAlamofire
                .request(resource.action)
                .responseJSON()
                .map { $0.data }
                .filter { $0 != nil }
                .map { $0! }
                .flatMap(resource.parse)
    }
    
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]> where T: Codable {
        return
            RxAlamofire
                .request(resource.action)
                .responseJSON()
                .map { $0.data ?? Data() }
                .flatMap(resource.parse)
    }
}
