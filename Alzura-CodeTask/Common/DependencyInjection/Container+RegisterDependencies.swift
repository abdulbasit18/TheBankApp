//
//  Container+RegisterDependencies.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerDependencies() {
        self.registerServices()
        self.registerCoordinators()
        self.registerViewModels()
        self.registerViewControllers()
    }
}
