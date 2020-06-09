//
//  String+Extension.swift
//  TheBankApp
//
//  Created by Abdul Basit on 01/06/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

extension String {
    var removeWhiteSpace: String {
        self.replacingOccurrences(of: " ", with: "")
    }
}
