//
//  SearchViewModel.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

// MARK: - Protocols
protocol SearchViewModelType: class {
    var searchSelected: BehaviorSubject<FilterModel?> { get }
    var backActionSubject: PublishSubject<Void> { get}
    var dismissSubject: PublishSubject<Void?> { get }
}

// MARK: - SearchViewModel Implementation
final class SearchViewModel: SearchViewModelType {
    
    var backActionSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    var searchSelected = BehaviorSubject<FilterModel?>.init(value: nil)
    var dismissSubject = PublishSubject<Void?>()
}
