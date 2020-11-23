//
//  BicModel.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - BicModel
struct BicModel: Codable, Equatable {
    var id, countryID: String?
    var bankName: String?
    var location, blz: String?
    var bicCode: String?
    var countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "countryId"
        case bankName, location, blz, bicCode, countryCode
    }
}
