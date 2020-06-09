//
//  ValidationView.swift
//  TheBankApp
//
//  Created by Abdul Basit on 27/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift

class SingleFieldValidationView: UIView {
    
    // MARK: - Properties
    
    let containerView = UIStackView()
    private let titleLbl = LeftAlignTextLabel()
    private let validationMessageView = ValidationMessageView()
    let validationButton = UIButton()
    private let disposeBag = DisposeBag()
    let singleValidationSelected = PublishSubject<String?>()
    let field = RoundedTextField()
    
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
    
    // MARK: - Functions
    
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
    
    internal func setupBindings() {
        
        validationButton.rx.tap.bind { [weak self] in
            guard let self = self else {return}
            self.singleValidationSelected.onNext(self.field.text)
            self.validationMessageView.isViewHidden = true
        }
        .disposed(by: disposeBag)
    }
    
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
