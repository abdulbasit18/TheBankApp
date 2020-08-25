//
//  Container+Controllers.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerViewControllers() {
        self.autoregister(MainListViewController.self, initializer: MainListViewController.init)
        self.autoregister(SearchViewController.self, initializer: SearchViewController.init)
        self.autoregister(ValidationViewController.self, initializer: ValidationViewController.init)
    }
}
