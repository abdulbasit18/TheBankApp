//
//  MockBicService.swift
//  TheBankAppTests
//
//  Created by Abdul Basit on 01/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

@testable import TheBankApp

struct MockEmptyService: NetworkService {
    func load<T>(_ resource: SingleItemResource<T>) -> Observable<T> where T: Decodable, T: Encodable {
     
        return Observable.error(CustomError(value: "Invalid"))
    }
    
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]> where T: Decodable, T: Encodable {
        
        return Observable.error(CustomError(value: "Not implemented"))
    }
    
}
