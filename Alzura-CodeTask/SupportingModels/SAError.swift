//
//  SAError.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct CustomError: LocalizedError {
    let value: String?
    var localizedDescription: String? {
        return value
    }
}
