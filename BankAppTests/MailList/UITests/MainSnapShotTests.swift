//
//  MainSnapShotTests.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase

@testable import Alzura_CodeTask

class MainSnapShotTests: FBSnapshotTestCase {
    
    var viewModel: MainListViewModelType!
    var service: NetworkService!
    var navigation: MainListCoordinator!
    var window: UIWindow!
    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        recordMode = SnapShotTestsConfiguration.recordMode
    }
    
    func testWhenDataIsNotAvailable() {
        service = MockEmptyService()
        viewModel = MainListViewModel(service)
        navigation = MainListCoordinator(viewModel: viewModel)
        navigation.start()
        let view = navigation.navigationController.topViewController?.view
        FBSnapshotVerifyView(view!)
        
    }
    
    func testWhenDataIsAvailable() {
        service = MockBicService()
        viewModel = MainListViewModel(service)
        navigation = MainListCoordinator(viewModel: viewModel)
        navigation.start()
        let view = navigation.navigationController.topViewController?.view
        FBSnapshotVerifyView(view!)
    }
}
