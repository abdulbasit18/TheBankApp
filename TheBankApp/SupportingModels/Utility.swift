//
//  Utility.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

func ignoreNil<A>(x: A?) -> Observable<A> {
    return x.map { Observable.just($0) } ?? Observable.empty()
}
