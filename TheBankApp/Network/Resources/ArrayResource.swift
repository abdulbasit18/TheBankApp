//
//  ArrayResource.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

struct ArrayResource<T: Codable> {
    let objectType = T.self
    let action: APIAction
    
    func parse(_ data: Data) -> Observable<[T]> {
        return Observable.create { observer in
            guard let result = try? JSONDecoder().decode([T].self, from: data) else {
                observer.onError(CustomError(value: "Can't map response."))
                return Disposables.create()
            }
            if let resultModel = result as? BaseModel, resultModel.status ?? false {
                observer.onError(CustomError(value: resultModel.message))
            }
            observer.onNext(result)
            return Disposables.create()
        }
    }
}
