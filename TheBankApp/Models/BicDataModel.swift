//
//  DataModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

// MARK: - DataModel
struct BicDataModel: Codable {
    var page, pageCount: Int?
    var bics: [BicModel?]?
    var location, bankName, countryCode, blz: String?
    var bic: String?
}
