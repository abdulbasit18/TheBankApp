//
//  NetworkService.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

protocol NetworkService {
    func load<T>(_ resource: SingleItemResource<T>) -> Observable<T>
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]>
}
