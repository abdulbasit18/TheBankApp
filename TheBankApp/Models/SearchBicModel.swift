//
//  SearchBicModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 29/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - SearchBicModel

struct SearchBicModel: Codable, BaseModel {
    var code: String?
    
    var message: String?
    
    var errorCode: String?
    
    var status: Bool?
    
    var data: BicDataModel?
}
