//
//  ValidationController.swift
//  TheBankApp
//
//  Created by Abdul Basit on 27/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

final class ValidationController: BaseViewController {
    
    // MARK: - Properties
    let viewModel: ValidationViewModelType
    private let containerStackView = UIStackView()
    private let bicValidationView = SingleFieldValidationView()
    private let ibanValidationView = SingleFieldValidationView()
    private let postCodeValidationView = DoubleFieldValidationView()
    private let spacerView = UIView()
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(_ viewModel: ValidationViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBindings()
    }
    
    private func setupUI() {
        // Title View Setup
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "Validations"
        let imageV = UIImageView()
        imageV.image = UIImage(named: "validation")
        stackView.addArrangedSubview(imageV)
        stackView.addArrangedSubview(label)
        stackView.axis = .horizontal
        stackView.spacing = 8
        navigationItem.titleView = stackView
        
        //Set BackGroundView
        view.backgroundColor = .white
        
        bicValidationView.configureView(title: "Validate BIC",
                                        placeHolder: "Please Enter BIC",
                                        buttonTitle: "Validate")
        
        ibanValidationView.configureView(title: "Validate IBAN",
                                         placeHolder: "Please Enter IBAN",
                                         buttonTitle: "Validate")
        
        postCodeValidationView.configureView(title: "Validate Post Code",
                                             firstPlaceHolder: "Please Enter Country",
                                             secondPlaceHolder: "Enter Post Code",
                                             buttonTitle: "Validate")
        
        self.navigationController?.navigationBar.tintColor = .black
        containerStackView.axis = .vertical
        containerStackView.addArrangedSubview(bicValidationView)
        containerStackView.addArrangedSubview(ibanValidationView)
        containerStackView.addArrangedSubview(postCodeValidationView)
        containerStackView.addArrangedSubview(spacerView)
        
        containerStackView.spacing = 20
        view.addSubview(containerStackView)
    }
    
    private func setupLayout() {
        
        //Stack View
        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    //Outputs
    private func setupBindings() {
        
        bicValidationView.field.rx
            .text
            .map { (text) -> String? in
                return text?.uppercased()
        }
        .subscribe(bicValidationView.field.rx.text)
        .disposed(by: disposeBag)
        
        ibanValidationView.field.rx
            .text
            .orEmpty
            .scan("") { (previous, new) -> String in
                var new = new
                let check = new.removeWhiteSpace
                if check.count % 4 == 0 && previous?.last != " " && !new.isEmpty {
                    new += " "
                }
                return new.uppercased()
        }
        .subscribe(ibanValidationView.field.rx.text)
        .disposed(by: disposeBag)
        
        postCodeValidationView.field.keyboardType = .numberPad
        
        //Triggered to View models
        updateViewModelBindings()
        //Triggered to Views
        updateViewsBindings()
    }
    
    //Outputs
    
    private func updateViewModelBindings() {
        
        bicValidationView
            .singleValidationSelected
            .bind(to: viewModel.inputs.bicValidationSelected)
            .disposed(by: disposeBag)
        
        ibanValidationView
            .singleValidationSelected
            .bind(to: viewModel.inputs.ibanValidationSelected)
            .disposed(by: disposeBag)
        
        postCodeValidationView
            .doubleValidationSelected
            .bind(to: viewModel.inputs.postCodeValidationSelected)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .subscribe { (event) in
                (event.element ?? false) ? self.startAnimating() : self.stopAnimating()
        }.disposed(by: disposeBag)
        
    }
    
    //Inputs
    
    private func updateViewsBindings() {
        viewModel.outputs
            .bicDataSubject
            .subscribe { [weak self] (status) in
                guard let status = status.element else {return}
                self?.bicValidationView.updateStatus(validation: status)
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs
            .ibanDataSubject
            .subscribe { [weak self] (status) in
                guard let status = status.element else {return}
                self?.ibanValidationView.updateStatus(validation: status)
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs
            .postDataSubject
            .skip(1)
            .subscribe { [weak self] (status) in
                guard let status = status.element else {return}
                self?.postCodeValidationView.updateStatus(validation: status)
        }
        .disposed(by: disposeBag)
    }
}
