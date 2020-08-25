//
//  SearchTests.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import XCTest
import RxSwift

@testable import Alzura_CodeTask

class SearchTests: XCTestCase {
    
    var viewModel: SearchViewModelType!
    var navigation: SearchCoordinator!
    var service: NetworkService!
    
    override func setUp() {
        service = BasicNetworkServiceImpl()
        viewModel = SearchViewModel()
        navigation = SearchCoordinator(viewModel: viewModel)
        navigation.start()
    }
    
    func testViewModelInitialState() {
        XCTAssertTrue(navigation.navigationController.topViewController is SearchViewController)
    }
    
}
