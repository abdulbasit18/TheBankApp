//
//  RoundedTextField.swift
//  TheBankApp
//
//  Created by Abdul Basit on 27/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

final class RoundedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
