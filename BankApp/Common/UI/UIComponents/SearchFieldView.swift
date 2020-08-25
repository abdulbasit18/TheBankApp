//
//  SearchFieldView.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SnapKit

final class SearchFieldView: UIView {
    // MARK: - Properties
    private let stackView = UIStackView()
    private let label = LeftAlignTextLabel()
    private let field = RoundedTextField()
    
    var text: String? { field.text }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(field)
        addSubview(stackView)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        field.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Configure
    func configureView(heading: String?, placeHolder: String?) {
        label.text = heading
        field.placeholder = placeHolder
    }
}
