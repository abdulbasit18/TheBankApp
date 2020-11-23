//
//  MainListViewModel.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Inputs Protocol
protocol MainListViewModelInputs: class {
    var searchActionSubject: PublishSubject<Void> { get }
    var validationSelectedSubject: PublishSubject<Void> { get }
    var reachedBottomSubject: PublishSubject<Void> { get }
    var searchSubject: BehaviorSubject<FilterModel?> { get }
    var viewDidLoadSubject: PublishSubject<Void?> { get }
}

// MARK: - Outputs Protocol
protocol MainListViewModelOutputs: class {
    var isLoadingSubject: PublishSubject<Bool> { get }
    var sourceData: BehaviorRelay<[BicModel]> { get }
    var errorSubject: PublishSubject<String> { get }
}

// MARK: - MainList Protocol
protocol MainListViewModelType: MainListViewModelInputs, MainListViewModelOutputs {
    var inputs: MainListViewModelInputs { get }
    var outputs: MainListViewModelOutputs { get }
}

// MARK: - MainListViewModel Implementation

final class MainListViewModel: MainListViewModelType {
    
    var outputs: MainListViewModelOutputs { self }
    var inputs: MainListViewModelInputs { self }
    
    // MARK: - Inputs
    let reachedBottomSubject = PublishSubject<Void>()
    var searchActionSubject = PublishSubject<Void>()
    var validationSelectedSubject = PublishSubject<Void>()
    var searchSubject = BehaviorSubject<FilterModel?>(value: nil)
    var viewDidLoadSubject = PublishSubject<Void?>()
    
    // MARK: - Outputs
    var isLoadingSubject = PublishSubject<Bool>()
    var errorSubject = PublishSubject<String>()
    var sourceData = BehaviorRelay<[BicModel]>(value: [])
    
    // MARK: - Properties
    private let service: NetworkService
    private let disposeBag = DisposeBag()
    var searchPersistentData: FilterModel?
    var page = 0
    
    // MARK: - Init
    init(_ service: NetworkService) {
        self.service = service
        
        //Setup RxBindings
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        //Fetch Bics on ViewDidLoad Invocation
        inputs.viewDidLoadSubject.subscribe(onNext: { [weak self] (_) in
            self?.fetchBics()
        }).disposed(by: disposeBag)
        
        //Fetch Pagination Bics When Scroll Reached to Bottom
        inputs.reachedBottomSubject
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe { [weak self ] (_) in
                guard let  self = self else {return}
                self.page += 1
                self.fetchBics(page: self.page)
        }
        .disposed(by: disposeBag)
        
        // Fetch Bics When Search is Triggered
        inputs.searchSubject.compactMap {$0}
            .subscribe(onNext: { [weak self] (searchModel) in
                guard let  self = self else {return}
                self.searchPersistentData = searchModel
                self.sourceData.accept([])
                self.page = 0
                self.fetchBics()
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Service Call
    private func fetchBics(page: Int = 0) {
        
        // Loader Start Animating
        outputs.isLoadingSubject.onNext(true)
        
        //Call Service to Fetch Bics
        service
            .load(SingleItemResource<SearchBicModel>(action:
                SearchBicAction.search(page: "\(page)",
                    search: searchPersistentData)))
            .flatMap(ignoreNil)
            .map({ [weak self] (model) -> [BicModel] in
                guard let  self = self else {return []}
                //Loader Stop Animating
                self.outputs.isLoadingSubject.onNext(false)
                // Fetch Previous Data and Add to the Received List
                let data = self.outputs.sourceData.value
                let bics =  data + (model.data?.bics?.compactMap {$0} ?? [])
                return (bics)
            })
            .subscribe(onNext: { [weak self] (bics) in
                guard let  self = self else {return }
                //Add Data to the Main Data Object
                self.outputs.sourceData.accept(bics)
                }, onError: { [weak self] (error) in
                    guard let  self = self else {return }
                    //Loader Stop Animating
                    self.outputs.isLoadingSubject.onNext(false)
                    //Show Error Alert
                    self.outputs.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
