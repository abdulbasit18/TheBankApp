//
//  ValidationCoordinator.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class ValidationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    private let viewModel: ValidationViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(viewModel: ValidationViewModelType) {
        self.viewModel = viewModel
    }
    
    // MARK: - Navigation
    override func start() {
        let viewController = ValidationViewController(viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
        
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        //Remove Coordinator From the Base When Screen is Dismissed
        viewModel.inputs
            .dismissSubject
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.parentCoordinator?.didFinish(coordinator: self)
            }).disposed(by: disposeBag)
        
    }
    
}
