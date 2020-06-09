//
//  MainSnapShotTests.swift
//  TheBankAppUITests
//
//  Created by Abdul Basit on 02/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase
import RxSwift

@testable import TheBankApp

class SearchSnapShotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = SnapShotTestsConfiguration.recordMode
    }
    
    func testSearchScreen() {
        let mockSearchSubject = BehaviorSubject<FilterModel?>(value: nil)
        let mockNavigationController = UINavigationController()
        let coordinator = SearchCoordinator(rootViewController: mockNavigationController,
                                            searchAction: mockSearchSubject)
        
        let viewModel = SearchViewModel(searchAction: mockSearchSubject, navigationDelegate: coordinator)
        
        let searchViewController = SearchController(viewModel)
        
        FBSnapshotVerifyViewController(searchViewController)
        
    }
}
