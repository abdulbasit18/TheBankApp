//
//  Container+ViewModels.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    
    func registerViewModels() {
        self.autoregister(MainListViewModelType.self, initializer: MainListViewModel.init)
        self.autoregister(ValidationViewModelType.self, initializer: ValidationViewModel.init)
        self.autoregister(SearchViewModelType.self, initializer: SearchViewModel.init)
    }
}
