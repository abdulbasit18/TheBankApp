//
//  ValidationMessageView.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

final class ValidationMessageView: UIStackView {
    
    // MARK: - Properties
    private let label = UILabel()
    var isViewHidden: Bool = false {
        didSet {
            label.isHidden = isViewHidden
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        self.axis = .vertical
        self.addArrangedSubview(label)
    }
    
    // MARK: - Configure
    func updateStatus(validation: ValidationStatus?) {
        guard let validation = validation else { return }
        self.isViewHidden = false
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: .curveEaseInOut, animations: {
                        switch validation {
                        case .success:
                            self.label.text = "Success"
                            self.label.backgroundColor = .green
                        case .failure:
                            self.label.text = "Failure"
                            self.label.backgroundColor = .orange
                        case .unknown:
                            self.isViewHidden = true
                        }
        })
    }
}
