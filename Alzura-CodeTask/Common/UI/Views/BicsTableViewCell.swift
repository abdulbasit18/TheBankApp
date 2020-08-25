//
//  BicsTableViewCell.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

final class BicsTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier = "SearchBic"
    
    // MARK: - Properties
    private let bankNameLabel = UILabel()
    private let blzLabel = UILabel()
    private let locationLabel = UILabel()
    private let countryCodeLabel = UILabel()
    private let bankImageView = UIImageView()
    private let containerStackView = UIStackView()
    private let bankBlzContainer = UIStackView()
    private let locationCountryContainer = UIStackView()
    private let contentStackView = UIStackView()
    private let spacerView = UIView()
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        guard contentView.subviews.isEmpty else {
            return
        }
        setupUI()
        layoutUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        //Setup Container StackView
        containerStackView.axis = .vertical
        
        //Setup Content StackView
        
        contentStackView.axis = .horizontal
        
        //Setup Bank Image
        bankImageView.image = UIImage(named: "bank")
        bankImageView.contentMode = .scaleAspectFit
        
        //Setup Bank Label
        bankNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bankNameLabel.textAlignment = .left
        
        //Setup Blz Label
        blzLabel.font = UIFont.systemFont(ofSize: 13)
        blzLabel.textAlignment = .right
        
        //Setup Location Label
        locationLabel.font = UIFont.systemFont(ofSize: 13)
        locationLabel.textAlignment = .left
        locationLabel.textColor = .lightGray
        
        //Setup Country Code Label
        countryCodeLabel.font = UIFont.italicSystemFont(ofSize: 13)
        countryCodeLabel.textAlignment = .right
        countryCodeLabel.textColor = .lightGray
    }
    
    // MARK: - Setup Layout
    private func layoutUI() {
        
        bankBlzContainer.axis = .horizontal
        bankBlzContainer.addArrangedSubview(bankNameLabel)
        bankBlzContainer.addArrangedSubview(blzLabel)
        bankBlzContainer.spacing = 8
        
        locationCountryContainer.axis = .horizontal
        locationCountryContainer.spacing = 8
        locationCountryContainer.addArrangedSubview(locationLabel)
        locationCountryContainer.addArrangedSubview(countryCodeLabel)
        
        bankNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        containerStackView.addArrangedSubview(bankBlzContainer)
        containerStackView.addArrangedSubview(locationCountryContainer)
        
        containerStackView.spacing = 10
        
        bankImageView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        contentStackView.addArrangedSubview(bankImageView)
        contentStackView.addArrangedSubview(containerStackView)
        
        contentView.addSubview(contentStackView)
        
        contentStackView.spacing = 20
        
        contentStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    // MARK: - Configure
    func configureWith(_ viewModel: BicModel) {
        bankNameLabel.text = viewModel.bankName
        blzLabel.text = viewModel.blz
        locationLabel.text = viewModel.location
        countryCodeLabel.text = viewModel.countryCode
    }
}
