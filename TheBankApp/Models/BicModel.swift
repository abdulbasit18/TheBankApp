//
//  BicModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - BicModel
struct BicModel: Codable, Equatable {
    var id, countryID: String?
    var bankName: String?
    var location, blz: String?
    var bicCode: String?
//    let bicCodeOther: String?
    var countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "countryId"
        case bankName, location, blz, bicCode, countryCode
    }
}
