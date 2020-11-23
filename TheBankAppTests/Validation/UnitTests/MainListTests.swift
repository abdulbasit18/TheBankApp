//
//  MainListTests.swift
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

class MainListTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel: MainListViewModel!
    var service: NetworkService!
    var coordinator: MainListCoordinator!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        service = MockBicService()
        viewModel = MainListViewModel(service)
        coordinator = MainListCoordinator(viewModel: viewModel)
    }
    
    func testViewModelInitialState() {
        XCTAssertEqual(viewModel.searchPersistentData, nil)
        XCTAssertEqual(viewModel.page, 0)
        XCTAssertEqual(try viewModel.inputs.searchSubject.toBlocking().first()!, nil)
        XCTAssertTrue(try viewModel.outputs.sourceData.toBlocking().first()!.isEmpty)
        
        coordinator.start()
        XCTAssertTrue(coordinator.navigationController.topViewController is MainListViewController)
        
    }
    
    func testFetchWithSearch() {
        
        // create testable observers
        
        let bicsObserver = scheduler.createObserver([BicModel].self)
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        viewModel.outputs.sourceData
            .bind(to: bicsObserver)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingSubject
            .bind(to: isLoadingObserver)
            .disposed(by: disposeBag)
        
        // when fetching the service
        
        let mockSearchModel = FilterModel()
        
        scheduler.createColdObservable([.next(10, mockSearchModel)])
            .bind(to: viewModel.inputs.searchSubject)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isLoadingObserver.events.first, .next(10, true))
        let receivedBicsCount = bicsObserver.events.last?.value.element?.count ?? 0
        XCTAssertEqual(receivedBicsCount, 15)

    }
    
    func testValidationNavigation() {

        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.inputs.validationSelectedSubject)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertTrue(coordinator.childCoordinators.last is ValidationCoordinator)
    }

    func testSearchNavigation() {

        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.inputs.searchActionSubject)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertTrue(coordinator.childCoordinators.last is SearchCoordinator)
    }
    
}
