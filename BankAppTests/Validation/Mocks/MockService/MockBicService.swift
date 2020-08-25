//
//  MockBicService.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

@testable import Alzura_CodeTask

struct MockBicService: NetworkService {
    func load<T>(_ resource: SingleItemResource<T>) -> Observable<T> where T: Decodable, T: Encodable {
        let testBundle = Bundle(for: MainListTests.self)
        
        if let urlBar = testBundle.url(forResource: "Bics", withExtension: "geojson") {
            do {
                let jsonData = try Data(contentsOf: urlBar)
                return resource.parse(jsonData)
            } catch { print("Error while parsing: \(error)") }
        }
        
        return Observable.error(CustomError(value: "Invalid"))
    }
    
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]> where T: Decodable, T: Encodable {
        
        return Observable.error(CustomError(value: "Not implemented"))
    }
    
}
