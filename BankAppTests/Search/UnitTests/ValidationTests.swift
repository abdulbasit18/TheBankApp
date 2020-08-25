//
//  ValidationTests.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import Alzura_CodeTask

class ValidationTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel: ValidationViewModelType!
    var navigation: ValidationCoordinator!
    var service: NetworkService!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        service = MockValidationService()
        viewModel = ValidationViewModel(service)
        navigation = ValidationCoordinator(viewModel: viewModel)
        navigation.start()
    }
    
    func testViewModelInitialState() {
        XCTAssertTrue(navigation.navigationController.topViewController is ValidationViewController)
        XCTAssertEqual(try viewModel.outputs.bicDataSubject.toBlocking().first()!, .unknown)
        XCTAssertEqual(try viewModel.outputs.ibanDataSubject.toBlocking().first()!, .unknown)
        XCTAssertEqual(try viewModel.outputs.postDataSubject.toBlocking().first()!, .unknown)
    }
    
    func testFetchBicValidation() {
        // create testable observers
        
        let bicValidationObserver = scheduler.createObserver(ValidationStatus.self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.bicDataSubject
            .bind(to: bicValidationObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .bind(to: isLoadingObserver)
            .disposed(by: disposeBag)
        
        // when fetching the service
        
        let bicString = "MALADE51KUS"
        
        scheduler.createColdObservable([.next(10, bicString)])
            .bind(to: viewModel.inputs.bicValidationSelected)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isLoadingObserver.events.first, .next(10, true))
        XCTAssertEqual(bicValidationObserver.events.last, .next(10, .success))
        
    }
    
    func testFetchIbanValidation() {
        // create testable observers
        
        let bicValidationObserver = scheduler.createObserver(ValidationStatus.self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.ibanDataSubject
            .bind(to: bicValidationObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .bind(to: isLoadingObserver)
            .disposed(by: disposeBag)
        
        // when fetching the service
        
        let ibanString = "DE12 5001 0517 0648 4898 90"
        
        scheduler.createColdObservable([.next(10, ibanString)])
            .bind(to: viewModel.inputs.ibanValidationSelected)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isLoadingObserver.events.first, .next(10, true))
        XCTAssertEqual(bicValidationObserver.events.last, .next(10, .success))
        
    }
    
    func testFetchPostCodeValidation() {
        // create testable observers
        
        let bicValidationObserver = scheduler.createObserver(ValidationStatus.self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.postDataSubject
            .bind(to: bicValidationObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .bind(to: isLoadingObserver)
            .disposed(by: disposeBag)
        
        // when fetching the service
        
        let postCodeValidationModel = DoubleFieldModel(firstFieldData: "DE",
                                                       secondFieldData: "67661")
        
        scheduler.createColdObservable([.next(10, postCodeValidationModel)])
            .bind(to: viewModel.inputs.postCodeValidationSelected)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isLoadingObserver.events.first, .next(10, true))
        XCTAssertEqual(bicValidationObserver.events.last, .next(10, .success))
        
    }
    
}
