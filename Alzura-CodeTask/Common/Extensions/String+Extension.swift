//
//  String+Extension.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

extension String {
    var removeWhiteSpace: String {
        self.replacingOccurrences(of: " ", with: "")
    }
}
