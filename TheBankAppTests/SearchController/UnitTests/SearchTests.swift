//
//  SearchTests.swift
//  TheBankAppTests
//
//  Created by Abdul Basit on 01/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import XCTest
import RxSwift

@testable import TheBankApp

class SearchTests: XCTestCase {

    var viewModel: SearchViewModelType!
    var navigation: SearchCoordinator!
    var service: NetworkService!
    
    override func setUp() {
        let mockNavigationController = UINavigationController()
        service = BasicNetworkServiceImpl()
        
        let mockSearchAction = BehaviorSubject<FilterModel?>(value: nil)
        
        navigation = SearchCoordinator(rootViewController: mockNavigationController,
                                       searchAction: mockSearchAction)
        navigation.start()
        viewModel = SearchViewModel(searchAction: mockSearchAction,
                                    navigationDelegate: navigation)
        
    }
    
    func testViewModelInitialState() {
        XCTAssertTrue(navigation.navigationController.topViewController is SearchController)
    }

}
