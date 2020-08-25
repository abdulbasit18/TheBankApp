//
//  ValidationViewModel.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

// MARK: - Inputs Protocol
protocol ValidationViewModelInputs: class {
    var bicValidationSelected: PublishSubject<String?> { get }
    var ibanValidationSelected: PublishSubject<String?> { get }
    var postCodeValidationSelected: PublishSubject<DoubleFieldModel?> { get }
    var dismissSubject: PublishSubject<Void?> { get }
}

// MARK: - Outputs Protocol
protocol ValidationViewModelOutputs: class {
    var bicDataSubject: BehaviorSubject<ValidationStatus> { get }
    var ibanDataSubject: BehaviorSubject<ValidationStatus> { get }
    var postDataSubject: BehaviorSubject<ValidationStatus> { get }
    var isLoading: PublishSubject<Bool> { get }
}

// MARK: - Main Protocol
protocol ValidationViewModelType: ValidationViewModelInputs, ValidationViewModelOutputs {
    var inputs: ValidationViewModelInputs { get }
    var outputs: ValidationViewModelOutputs { get }
}

// MARK: - ValidationViewModel Implementation
final class ValidationViewModel: ValidationViewModelType {
    
    var inputs: ValidationViewModelInputs { self }
    var outputs: ValidationViewModelOutputs { self }
    
    // MARK: - Inputs
    var bicValidationSelected =  PublishSubject<String?>()
    var ibanValidationSelected =  PublishSubject<String?>()
    var postCodeValidationSelected = PublishSubject<DoubleFieldModel?>()
    var dismissSubject = PublishSubject<Void?>()
    
    // MARK: - Outputs
    var bicDataSubject = BehaviorSubject<ValidationStatus>(value: .unknown)
    var ibanDataSubject = BehaviorSubject<ValidationStatus>(value: .unknown)
    var postDataSubject = BehaviorSubject<ValidationStatus>(value: .unknown)
    var isLoading = PublishSubject<Bool>()
    
    // MARK: - Private Properties
    private let service: NetworkService
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(_ service: NetworkService) {
        self.service = service
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        //Validate Bic on tapping Bic Validation Button
        inputs
            .bicValidationSelected
            .subscribe(onNext: { [weak self] (bic) in
                self?.validateBic(text: bic)
            }).disposed(by: disposeBag)
        
        //Validate Iban on tapping Iban Validation Button
        inputs
            .ibanValidationSelected
            .subscribe(onNext: { [weak self] (iban) in
                self?.validateIban(text: iban)
            }).disposed(by: disposeBag)
        
        //Validate Post Code on tapping Post Code Validation Button
        inputs
            .postCodeValidationSelected
            .subscribe(onNext: { [weak self] (postCodeModel) in
                self?.validatePostCode(countryCode: postCodeModel?.firstFieldData,
                                       postCode: postCodeModel?.secondFieldData)
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Validations
    private func validateBic(text: String?) {
        // Start Loader Animation
        isLoading.onNext(true)
        //Service Call
        service
            .load(SingleItemResource<ValidationModel>(action:
                ValidateAction.validateBic(value: text)))
            .map({ [weak self] (model) -> ValidationStatus in
                // Stop Loader Animation
                self?.isLoading.onNext(false)
                // Update Model
                return model.codeStatus
            })
            .subscribe(bicDataSubject)
            .disposed(by: disposeBag)
    }
    
    private func validateIban(text: String?) {
        // Start Loader Animation
        isLoading.onNext(true)
        //Service Call
        service
            .load(SingleItemResource<ValidationModel>(action:
                ValidateAction.validateIban(value: text)))
            .map({ [weak self] (model) -> ValidationStatus in
                // Stop Loader Animation
                self?.isLoading.onNext(false)
                // Update Model
                return model.codeStatus
            })
            .subscribe(ibanDataSubject)
            .disposed(by: disposeBag)
    }
    
    private func validatePostCode(countryCode: String?, postCode: String?) {
        // Start Loader Animation
        isLoading.onNext(true)
        //Service Call
        service
            .load(SingleItemResource<ValidationModel>(action:
                ValidateAction.validatePostCode(countryCode: countryCode, postCode: postCode)))
            .flatMap(ignoreNil)
            .map({ [weak self] (model) -> ValidationStatus in
                // Stop Loader Animation
                self?.isLoading.onNext(false)
                // Update Model
                return model.codeStatus
            })
            .subscribe(postDataSubject)
            .disposed(by: disposeBag)
    }
}
