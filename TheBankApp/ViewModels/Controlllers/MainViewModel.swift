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

protocol MainViewModelInputs: class {
    var searchActionSubject: PublishSubject<Any> { get }
    var validationSelectedSubject: PublishSubject<Any> { get }
    var reachedBottomSubject: PublishSubject<Void> { get }
    var searchSubject: BehaviorSubject<FilterModel?> { get }
}

// MARK: - Outputs Protocol

protocol MainViewModelOutputs: class {
    var isLoadingSubject: PublishSubject<Bool> { get }
    var sourceData: BehaviorRelay<[BicModel]> { get }
    var errorSubject: PublishSubject<String> { get }
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
    
    let reachedBottomSubject = PublishSubject<Void>()
    var searchActionSubject = PublishSubject<Any>()
    var validationSelectedSubject = PublishSubject<Any>()
    var searchSubject = BehaviorSubject<FilterModel?>(value: nil)
    
    // MARK: - Outputs
    var isLoadingSubject = PublishSubject<Bool>()
    var errorSubject = PublishSubject<String>()
    var sourceData = BehaviorRelay<[BicModel]>(value: [])
    
    // MARK: - Private Properties
    
    private let service: NetworkService
    private let navigationDelegate: NavigationDelegate
    private let disposeBag = DisposeBag()
    private var searchPersistentData: FilterModel?
    private var page = 0
    
    // MARK: - Init 
    init(_ service: NetworkService, navigationDelegate: NavigationDelegate) {
        self.service = service
        self.navigationDelegate = navigationDelegate
        
        //Setup RxBindings
        setupBindings()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        inputs.searchActionSubject
            .subscribe { [weak self] (_) in
                guard let  self = self else {return}
                self.navigationDelegate.filterSelected(searchAction: self.searchSubject)
        }
        .disposed(by: disposeBag)
        
        inputs.validationSelectedSubject
            .subscribe { [weak self] (_) in
                self?.navigationDelegate.validationSelected()
        }
        .disposed(by: disposeBag)
        
        inputs.reachedBottomSubject
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe { [weak self ] (_) in
                guard let  self = self else {return}
                self.page += 1
                self.fetchBics(page: self.page)
        }
        .disposed(by: disposeBag)
        
        inputs.searchSubject
            .compactMap {$0}
            .subscribe { [weak self] (searchModel) in
                guard let  self = self else {return}
                self.searchPersistentData = searchModel.element
                self.sourceData.accept([])
                self.page = 0
                self.fetchBics()
        }
        .disposed(by: disposeBag)
        
    }
    
    // MARK: - Service Call
    func fetchBics(page: Int = 0) {
        outputs.isLoadingSubject.onNext(true)
        service
            .load(SingleItemResource<SearchBicModel>(action:
                SearchBicAction.search(page: "\(page)",
                    search: searchPersistentData)))
            .flatMap(ignoreNil)
            .map({ [weak self] (model) -> [BicModel] in
                guard let  self = self else {return []}
                self.outputs.isLoadingSubject.onNext(false)
                let data = self.outputs.sourceData.value
                let bics =  data + (model.data?.bics?.compactMap {$0} ?? [])
                return (bics)
            })
            .subscribe(onNext: { [weak self] (bics) in
                guard let  self = self else {return }
                self.outputs.sourceData.accept(bics)
                }, onError: { [weak self] (error) in
                    guard let  self = self else {return }
                    self.outputs.isLoadingSubject.onNext(false)
                    self.outputs.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
