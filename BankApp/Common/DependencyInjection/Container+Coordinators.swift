//
//  Container+Coordinators.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerCoordinators() {
        self.autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        self.autoregister(MainListCoordinator.self, initializer: MainListCoordinator.init)
        self.autoregister(ValidationCoordinator.self, initializer: ValidationCoordinator.init)
        self.autoregister(SearchCoordinator.self, initializer: SearchCoordinator.init)
    }
}
