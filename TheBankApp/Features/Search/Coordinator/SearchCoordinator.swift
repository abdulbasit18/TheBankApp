//
//  SearchCoordinator.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class SearchCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    var searchSubject: BehaviorSubject<FilterModel?> = .init(value: nil)
    private let viewModel: SearchViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(viewModel: SearchViewModelType) {
        self.viewModel = viewModel
    }
    
    // MARK: - Navigation
    override func start() {
        let viewController = SearchViewController(viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
        
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        // Bind Search Action
        viewModel.searchSelected
            .skip(1)
            .bind(to: searchSubject)
            .disposed(by: disposeBag)
        
        //Remove Coordinator From the Base When Screen is Dismissed
        viewModel.dismissSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.parentCoordinator?.didFinish(coordinator: self)
        }).disposed(by: disposeBag)
        
    }
}
