//
//  DoubleFieldValidationView.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

final class DoubleFieldValidationView: SingleFieldValidationView {
    
    // MARK: - Properties
    private let firstField = RoundedTextField()
    private let disposeBag = DisposeBag()
    var doubleValidationSelected = PublishSubject<DoubleFieldModel>()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.containerView.insertArrangedSubview(firstField, at: 1)
    }
    
    private func setupLayout() {
        firstField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Setup Bindings
    override func setupBindings() {
        validationButton.rx.tap.bind { [weak self] in
            guard let self = self else {return}
            let model = DoubleFieldModel(firstFieldData: self.firstField.text, secondFieldData: self.field.text)
            self
                .doubleValidationSelected
                .onNext(model)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureView(title: String?,
                       firstPlaceHolder: String?,
                       secondPlaceHolder: String?,
                       buttonTitle: String?) {
        configureView(title: title, placeHolder: secondPlaceHolder, buttonTitle: buttonTitle)
        firstField.placeholder = firstPlaceHolder
    }
    
}
