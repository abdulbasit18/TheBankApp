//
//  NavigationDelegate.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

protocol NavigationDelegate: class {
    func filterSelected(searchAction: BehaviorSubject<FilterModel?>)
    func validationSelected()
}
