//
//  SearchCoordinator.swift
//  TheBankApp
//
//  Created by Abdul Basit on 24/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift

final class SearchCoordinator: Coordinator {
    
    var searchAction: BehaviorSubject<FilterModel?>
    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []
    
    init(rootViewController: UINavigationController, searchAction: BehaviorSubject<FilterModel?> ) {
        navigationController = rootViewController
        self.searchAction = searchAction
    }
    
    func start() {
        let filterViewController = SearchController(SearchViewModel(searchAction: searchAction,
                                                                    navigationDelegate: self))
        navigationController.pushViewController(filterViewController, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
  
}

extension SearchCoordinator: SearchNavigationDelegate {
    
}
