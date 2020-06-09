//
//  BaseModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - BaseModel
protocol BaseModel: Codable {
    var code: String? { get }
    var message: String? { get }
    var errorCode: String? { get }
    var status: Bool? { get }
}
