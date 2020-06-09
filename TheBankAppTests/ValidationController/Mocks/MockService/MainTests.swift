//
//  MainTests.swift
//  Alzura-CodeTaskTests
//
//  Created by Abdul Basit on 01/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking

@testable import Alzura_CodeTask

class MainTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel: MainViewModelType!
    var service: NetworkService!
    var navigation: MainCoordinator!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        let mockWindow = UIWindow(frame: UIScreen.main.bounds)
        service = MockBicService()
        navigation = MainCoordinator.init(mockWindow, service: service)
        navigation.start()
        viewModel = MainViewModel(service, navigationDelegate: navigation)
    }
    
    func testViewModelInitialState() {
        XCTAssertTrue(navigation.navigationController.topViewController is MainController)
        XCTAssertEqual(viewModel.outputs.searchPersistentData, nil)
        XCTAssertEqual(viewModel.page, 0)
        XCTAssertEqual(try viewModel.inputs.searchSubject.toBlocking().first()!, nil)
        XCTAssertTrue(try viewModel.outputs.tableData.toBlocking().first()!.isEmpty)
        
    }

    func testFetchWithSearch() {
        // create testable observers

        let bicsObserver = scheduler.createObserver([BicModel].self)

        viewModel.outputs.tableData
            .bind(to: bicsObserver)
            .disposed(by: disposeBag)

        // when fetching the service

        let mockSearchModel = FilterModel()

        scheduler.createColdObservable([.next(10, mockSearchModel)])
            .bind(to: viewModel.inputs.searchSubject)
        .disposed(by: disposeBag)

        scheduler.start()
        
        let receivedBicsCount = bicsObserver.events.last?.value.element?.count ?? 0

        XCTAssertEqual(receivedBicsCount, 15)
    }

}
