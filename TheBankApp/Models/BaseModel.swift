//
//  BaseModel.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - BaseModel
protocol BaseModel: Codable {
    var code: String? { get }
    var message: String? { get }
    var errorCode: String? { get }
    var status: Bool? { get }
}
