//
//  SearchSnapShotTests.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase
import RxSwift

@testable import Alzura_CodeTask

class SearchSnapShotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = SnapShotTestsConfiguration.recordMode
    }
    
    func testSearchScreen() {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel)
        
        FBSnapshotVerifyViewController(searchViewController)
    }
}
