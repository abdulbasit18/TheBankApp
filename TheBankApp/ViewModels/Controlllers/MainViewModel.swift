//
//  MainControllerViewModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Inputs Protocol

protocol MainViewModelInputs {
    var searchButtonActionSubject: PublishSubject<Any> { get }
    var validationSelectedSubject: PublishSubject<Any> { get }
    var reachedBottomTrigger: PublishSubject<Void> { get }
    var searchSubject: BehaviorSubject<FilterModel?> { get }
}

// MARK: - Outputs Protocol

protocol MainViewModelOutputs {
    var isLoading: PublishSubject<Bool> { get }
    var tableData: BehaviorRelay<[BicModel]> { get }
    var errorSubject: PublishSubject<String> { get }
    var searchPersistentData: FilterModel? { get }
    var page: Int { get }
}

// MARK: - Main Protocol

protocol MainViewModelType: MainViewModelInputs, MainViewModelOutputs {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

// MARK: - ViewModel

final class MainViewModel: MainViewModelType {
    
    var outputs: MainViewModelOutputs { self }
    var inputs: MainViewModelInputs { self }
    
    // MARK: - Inputs
    
    let reachedBottomTrigger = PublishSubject<Void>()
    var searchButtonActionSubject = PublishSubject<Any>()
    var validationSelectedSubject = PublishSubject<Any>()
    var searchSubject = BehaviorSubject<FilterModel?>(value: nil)
    
    // MARK: - Outputs
    var isLoading = PublishSubject<Bool>()
    var errorSubject = PublishSubject<String>()
    var tableData = BehaviorRelay<[BicModel]>(value: [])
    var searchPersistentData: FilterModel?
    var page = 0
    
    // MARK: - Private Properties
    
    private let service: NetworkService
    private let disposeBag = DisposeBag()
    
    // MARK: - Init 
    init(_ service: NetworkService, navigationDelegate: NavigationDelegate) {
        self.service = service
        
        searchButtonActionSubject
            .subscribe { [weak self] (_) in
                guard let  self = self else {return}
                navigationDelegate.filterSelected(searchAction: self.searchSubject)
        }
        .disposed(by: disposeBag)
        
        validationSelectedSubject
            .subscribe { (_) in
                navigationDelegate.validationSelected()
        }
        .disposed(by: disposeBag)
        
        reachedBottomTrigger
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe { [weak self ] (_) in
                guard let  self = self else {return}
                self.page += 1
                self.fetchBics(page: self.page)
        }
        .disposed(by: disposeBag)
        
        searchSubject
            .compactMap {$0}
            .subscribe { [weak self] (searchModel) in
                guard let  self = self else {return}
                self.searchPersistentData = searchModel.element
                self.tableData.accept([])
                self.fetchBics()
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Service Call
    func fetchBics(page: Int = 0) {
        isLoading.onNext(true)
        service
            .load(SingleItemResource<SearchBicModel>(action:
                SearchBicAction.search(page: "\(page)",
                    search: searchPersistentData)))
            .flatMap(ignoreNil)
            .map({ [weak self] (model) -> [BicModel] in
                guard let  self = self else {return []}
                self.isLoading.onNext(false)
                let data = self.tableData.value
                let bics =  data + (model.data?.bics?.compactMap {$0} ?? [])
                return (bics)
            })
            .subscribe(onNext: { [weak self] (bics) in
                guard let  self = self else {return }
                self.tableData.accept(bics)
                }, onError: { [weak self] (error) in
                    guard let  self = self else {return }
                    self.isLoading.onNext(false)
                    self.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
