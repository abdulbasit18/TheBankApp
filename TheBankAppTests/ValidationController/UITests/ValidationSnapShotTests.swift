//
//  MainSnapShotTests.swift
//  TheBankAppUITests
//
//  Created by Abdul Basit on 02/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase

@testable import TheBankApp

class ValidationSnapShotTests: FBSnapshotTestCase {
    
    var viewModel: ValidationViewModelType!
    var service: NetworkService!

    override func setUp() {
        super.setUp()
        service = MockValidationService()
        viewModel = ValidationViewModel(service)
        
        recordMode = SnapShotTestsConfiguration.recordMode
    }

    func testMainScreen() {
        let validationController = ValidationController(viewModel)
        let validationView = validationController.view
        FBSnapshotVerifyView(validationView!)
    }
}
