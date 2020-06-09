//
//  ValidationViewModel.swift
//  TheBankApp
//
//  Created by Abdul Basit on 27/05/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

// MARK: - Inputs Protocol
protocol ValidationViewModelInputs {
    var bicValidationSelected: PublishSubject<String?> { get }
    var ibanValidationSelected: PublishSubject<String?> { get }
    var postCodeValidationSelected: PublishSubject<DoubleFieldModel?> { get }
}

// MARK: - Outputs Protocol
protocol ValidationViewModelOutputs {
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

// MARK: - ViewModel
final class ValidationViewModel: ValidationViewModelType {
    
    var inputs: ValidationViewModelInputs { self }
    var outputs: ValidationViewModelOutputs { self }
    
    // MARK: - Inputs
    var bicDataSubject = BehaviorSubject<ValidationStatus>(value: .unknown)
    var ibanDataSubject = BehaviorSubject<ValidationStatus>(value: .unknown)
    var postDataSubject = BehaviorSubject<ValidationStatus>(value: .unknown)
    
    // MARK: - Outputs
    var bicValidationSelected =  PublishSubject<String?>()
    var ibanValidationSelected =  PublishSubject<String?>()
    var postCodeValidationSelected = PublishSubject<DoubleFieldModel?>()
    var isLoading = PublishSubject<Bool>()
    
    // MARK: - Private Properties
    private let service: NetworkService
    private let disposeBag = DisposeBag()
    
    init(_ service: NetworkService) {
        
        self.service = service
        
        bicValidationSelected
            .flatMap(ignoreNil)
            .subscribe { [weak self] (event) in
                let bic = event.element
                self?.validateBic(text: bic)
        }
        .disposed(by: disposeBag)
        
        ibanValidationSelected
            .flatMap(ignoreNil)
            .subscribe { (event) in
                let iban = event.element
                self.validateIban(text: iban)
        }
        .disposed(by: disposeBag)
        
        postCodeValidationSelected
            .flatMap(ignoreNil)
            .subscribe { (event) in
                let postCodeModel = event.element
                self.validatePostCode(countryCode: postCodeModel?.firstFieldData,
                                      postCode: postCodeModel?.secondFieldData)
        }
        .disposed(by: disposeBag)
    }
    
    private func validateBic(text: String?) {
        isLoading.onNext(true)
        service
            .load(SingleItemResource<ValidationModel>(action:
                ValidateAction.validateBic(value: text)))
            .map({ [weak self] (model) -> ValidationStatus in
                self?.isLoading.onNext(false)
                return model.codeStatus
            })
            .subscribe(bicDataSubject)
            .disposed(by: disposeBag)
    }
    
    private func validateIban(text: String?) {
        isLoading.onNext(true)
        service
            .load(SingleItemResource<ValidationModel>(action:
                ValidateAction.validateIban(value: text)))
            .map({ [weak self] (model) -> ValidationStatus in
                self?.isLoading.onNext(false)
                return model.codeStatus
            })
            .subscribe(ibanDataSubject)
            .disposed(by: disposeBag)
    }
    
    private func validatePostCode(countryCode: String?, postCode: String?) {
        isLoading.onNext(true)
        service
            .load(SingleItemResource<ValidationModel>(action:
                ValidateAction.validatePostCode(countryCode: countryCode, postCode: postCode)))
            .flatMap(ignoreNil)
            .map({ [weak self] (model) -> ValidationStatus in
                self?.isLoading.onNext(false)
                return model.codeStatus
            })
            .subscribe(postDataSubject)
            .disposed(by: disposeBag)
    }
}
