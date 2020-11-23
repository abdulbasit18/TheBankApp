//
//  MainListCoordinator.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class MainListCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    private let viewModel: MainListViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(viewModel: MainListViewModelType) {
        self.viewModel = viewModel
        super.init()
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    // MARK: - Start
    override func start() {
        let viewController = MainListViewController(self.viewModel)
        self.navigationController.setViewControllers([viewController], animated: true)
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        //Navigate to Validation Screen on Invocation
        viewModel.inputs.validationSelectedSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToValidation()
            }).disposed(by: disposeBag)
        //Navigate to Search Screen on Invocation
        viewModel.inputs.searchActionSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToSearch()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    private func navigateToValidation() {
        // Inject Validation Coordinator and is Dependencies
        let validationCoordinator = AppDelegate.container.resolve(ValidationCoordinator.self)!
        //Set Base Coordinator Configuration
        validationCoordinator.navigationController = self.navigationController
        validationCoordinator.parentCoordinator = self
        //Navigate To Validation View Controller
        self.start(coordinator: validationCoordinator)
    }
    
    private func navigateToSearch() {
        // Inject Search Coordinator and is Dependencies
        let searchCoordinator = AppDelegate.container.resolve(SearchCoordinator.self)!
        //Set Base Coordinator Configuration
        searchCoordinator.navigationController = self.navigationController
        searchCoordinator.parentCoordinator = self
        
        /*Shared Search Action Subject Which binds
         to Bic Data Fetch Service and to dismiss the Controller */
        let sharedSubject = searchCoordinator.searchSubject.share()
        
        sharedSubject
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        sharedSubject
            .subscribe(onNext: { [weak self] (_) in
                self?.dismissSearchCoordinator()
            }).disposed(by: disposeBag)
        
        self.start(coordinator: searchCoordinator)
    }
    
    //Dismiss Coordinator on Filter Action
    private func dismissSearchCoordinator() {
        self.navigationController.popToRootViewController(animated: true)
        self.removeChildCoordinators()
    }
}
