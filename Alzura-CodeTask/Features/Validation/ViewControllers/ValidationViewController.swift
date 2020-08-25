//
//  ValidationViewController.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

final class ValidationViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: ValidationViewModelType
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParent {
            viewModel.inputs.dismissSubject.onNext(nil)
        }
    }
    
    // MARK: - UI Setup
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
        
        postCodeValidationView.field.keyboardType = .numberPad
        
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
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        // Upper Case Bic Field Letter on Typing
        bicValidationView.field.rx
            .text
            .map {$0?.uppercased()}
            .bind(to: bicValidationView.field.rx.text)
            .disposed(by: disposeBag)
        
        // Upper Case and Group 4 Character Iban Field Letter on Typing
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
        
        //Triggered to View models
        updateViewModelBindings()
        //Triggered to Views
        updateViewsBindings()
    }
    
    //Outputs
    
    private func updateViewModelBindings() {
        //Validate Bic on Button Tap
        bicValidationView
            .singleValidationSelected
            .bind(to: viewModel.inputs.bicValidationSelected)
            .disposed(by: disposeBag)
        
        //Validate Iban on Button Tap
        ibanValidationView
            .singleValidationSelected
            .bind(to: viewModel.inputs.ibanValidationSelected)
            .disposed(by: disposeBag)
        
        //Validate Post Code on Button Tap
        postCodeValidationView
            .doubleValidationSelected
            .bind(to: viewModel.inputs.postCodeValidationSelected)
            .disposed(by: disposeBag)
        
        // Update Loader Animation
        viewModel.outputs.isLoading.subscribe(onNext: { [weak self] (isAnimating) in
            guard let self = self else { return }
            isAnimating ? self.startAnimating() : self.stopAnimating()
        }).disposed(by: disposeBag)
        
    }
    
    //Inputs
    private func updateViewsBindings() {
        
        //Update Bic Validation From Service
        viewModel.outputs
            .bicDataSubject
            .subscribe(onNext: { [weak self] (status) in
                self?.bicValidationView.updateStatus(validation: status)
            }).disposed(by: disposeBag)
        
        //Update Iban Validation From Service
        viewModel.outputs
            .ibanDataSubject
            .subscribe(onNext: { [weak self] (status) in
                self?.ibanValidationView.updateStatus(validation: status)
            }).disposed(by: disposeBag)
        
        //Update Post Code Validation From Service
        viewModel.outputs
            .postDataSubject
            .subscribe(onNext: { [weak self] (status) in
                self?.postCodeValidationView.updateStatus(validation: status)
            }).disposed(by: disposeBag)
        
    }
}
