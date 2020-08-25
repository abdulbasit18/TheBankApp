//
//  Container+Services.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    
    func registerServices() {
        self.autoregister(NetworkService.self,
                          initializer: BasicNetworkServiceImpl.init).inObjectScope(.container)
    }
}
