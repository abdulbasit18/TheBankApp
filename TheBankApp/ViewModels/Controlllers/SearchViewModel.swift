//
//  SearchViewModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 24/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

protocol SearchViewModelType: class {
    var searchSelected: BehaviorSubject<FilterModel?> { get }
}

final class SearchViewModel: SearchViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var searchSelected = BehaviorSubject<FilterModel?>(value: nil)
    
    init(searchAction: BehaviorSubject<FilterModel?>,
         navigationDelegate: SearchNavigationDelegate ) {
        searchSelected
        .skip(1)
            .bind(to: searchAction)
            .disposed(by: disposeBag)
        
        searchSelected.subscribe { (_) in
            navigationDelegate.dismiss()
        }
        .disposed(by: disposeBag)

    }
}
