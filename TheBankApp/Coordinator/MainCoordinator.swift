//
//  AppCoordinator.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift

/// Main app coordinator that manages basic app flow
final class MainCoordinator: Coordinator {
    
    // Init
    init(_ window: UIWindow, service: NetworkService) {
        self.window = window
        networkService = service
    }
    
    // MARK: - Properties
    let navigationController = UINavigationController()
    private let window: UIWindow
    
    var networkService: NetworkService
    var childCoordinators = [Coordinator]()
    
    // MARK: - Functions
    func start() {
        let mainViewModel = MainViewModel(networkService, navigationDelegate: self)
        let controller = MainController(mainViewModel)
        navigationController.setViewControllers([controller], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension MainCoordinator: NavigationDelegate {
    func validationSelected() {
        let validationCoordinator = ValidationCoordinator(rootViewController: navigationController)
        self.addChildCoordinator(validationCoordinator)
        validationCoordinator.start()
    }
    
    func filterSelected(searchAction: BehaviorSubject<FilterModel?>) {
        let searchCoodinator = SearchCoordinator(rootViewController: navigationController, searchAction: searchAction)
        self.addChildCoordinator(searchCoodinator)
        searchCoodinator.start()
        
    }
    
}
