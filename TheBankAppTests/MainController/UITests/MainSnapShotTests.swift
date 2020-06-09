//
//  MainSnapShotTests.swift
//  TheBankAppUITests
//
//  Created by Abdul Basit on 02/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase

@testable import TheBankApp

class MainSnapShotTests: FBSnapshotTestCase {
    
    var viewModel: MainViewModelType!
    var service: NetworkService!
    var navigation: MainCoordinator!
    var window: UIWindow!
    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        recordMode = SnapShotTestsConfiguration.recordMode
    }

    func testWhenDataIsNotAvailable() {
        service = MockEmptyService()
        navigation = MainCoordinator.init(window, service: service)
        navigation.start()
        viewModel = MainViewModel(service, navigationDelegate: navigation)
        let view = navigation.navigationController.topViewController?.view
        FBSnapshotVerifyView(view!)
        
    }
    
    func testWhenDataIsAvailable() {
        service = MockBicService()
        navigation = MainCoordinator.init(window, service: service)
        navigation.start()
        viewModel = MainViewModel(service, navigationDelegate: navigation)
        let view = navigation.navigationController.topViewController?.view
        FBSnapshotVerifyView(view!)
    }
}
