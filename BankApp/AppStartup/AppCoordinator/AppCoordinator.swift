//
//  AppCoordinator.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

final class AppCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        //Inject Main Coordinator
        let coordinator = AppDelegate.container.resolve(MainListCoordinator.self)!
        self.start(coordinator: coordinator)
        // Set MainList View as Root View Controlller
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
    }
}
