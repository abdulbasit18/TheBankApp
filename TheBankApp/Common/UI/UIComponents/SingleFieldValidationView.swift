//
//  SingleFieldValidationView.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class SingleFieldValidationView: UIView {
    
    // MARK: - Properties
    let containerView = UIStackView()
    let validationButton = UIButton()
    let singleValidationSelected = PublishSubject<String?>()
    let field = RoundedTextField()
    private let titleLbl = LeftAlignTextLabel()
    private let validationMessageView = ValidationMessageView()
    private let disposeBag = DisposeBag()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        containerView.addArrangedSubview(titleLbl)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(field)
        stackView.addArrangedSubview(validationMessageView)
        
        containerView.addArrangedSubview(stackView)
        containerView.addArrangedSubview(validationButton)
        containerView.axis = .vertical
        containerView.spacing = 20
        containerView.backgroundColor = .brown
        addSubview(containerView)
        
        validationButton.setTitleColor(.black, for: .normal)
    }
    
    private func setupLayout() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        field.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Bindings
    internal func setupBindings() {
        
        validationButton.rx.tap.bind { [weak self] in
            guard let self = self else {return}
            self.singleValidationSelected.onNext(self.field.text)
            self.validationMessageView.isViewHidden = true
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Configuration
    func configureView(title: String?,
                       placeHolder: String?,
                       buttonTitle: String?) {
        titleLbl.text = title
        field.placeholder = placeHolder
        validationButton.setTitle(buttonTitle, for: .normal)
    }
    
    func updateStatus(validation: ValidationStatus?) {
        validationMessageView.updateStatus(validation: validation)
    }
    
}
