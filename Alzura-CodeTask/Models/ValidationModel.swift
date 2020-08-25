//
//  ValidationModel.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - ValidationModel
struct ValidationModel: Codable, BaseModel {
    var code: String?
    var message: String?
    var errorCode: String?
    var status: Bool?
    var data: ValidationDataModel?
    var codeStatus: ValidationStatus {
        code == "OK" ? .success : .failure
    }
}
