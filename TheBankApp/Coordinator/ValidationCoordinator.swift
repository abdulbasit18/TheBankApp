//
//  ValidationCoordinator.swift
//  TheBankApp
//
//  Created by Abdul Basit on 27/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift

final class ValidationCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var networkService: NetworkService = BasicNetworkServiceImpl()
    
    init(rootViewController: UINavigationController) {
        navigationController = rootViewController
    }
    
    func start() {
        let validationViewController = ValidationController(ValidationViewModel(networkService))
        navigationController.pushViewController(validationViewController, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
  
}

extension SearchCoordinator: ValidationNavigationDelegate {
}
