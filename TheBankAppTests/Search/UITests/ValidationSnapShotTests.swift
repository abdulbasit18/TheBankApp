//
//  ValidationSnapShotTests.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase

@testable import Alzura_CodeTask

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
        let validationController = ValidationViewController(viewModel)
        let validationView = validationController.view
        FBSnapshotVerifyView(validationView!)
    }
}
