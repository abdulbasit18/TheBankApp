//
//  LeftAlignTextLabel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 27/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

final class LeftAlignTextLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
