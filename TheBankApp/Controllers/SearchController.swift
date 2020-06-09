//
//  SearchController.swift
//  TheBankApp
//
//  Created by Abdul Basit on 11/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

final class SearchController: BaseViewController {
    
    // MARK: - Properties
    let viewModel: SearchViewModelType
    private let disposeBag = DisposeBag()
    private let containerStackView = UIStackView()
    private var blzView = SearchFieldView()
    private var countryView = SearchFieldView()
    private var bankView = SearchFieldView()
    private var locationView = SearchFieldView()
    private let searchButton = UIButton()
    private let spacerView = UIView()
    private let tapBackground = UITapGestureRecognizer()
    
    // MARK: - Init
    init(_ viewModel: SearchViewModelType) {
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
        layoutUI()
        setupBindings()
    }
    
    private func setupUI() {
        
        // Title View Setup
        view.backgroundColor = .white
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "Filter"
        let imageV = UIImageView()
        imageV.image = UIImage(named: "filter")
        stackView.addArrangedSubview(imageV)
        stackView.addArrangedSubview(label)
        stackView.axis = .horizontal
        stackView.spacing = 8
        navigationItem.titleView = stackView
        
        //Set BackGroundView
        view.backgroundColor = .white
        
        // Adding Field Views
        blzView.configureView(heading: "Search BLZ",
                              placeHolder: "Please Enter BLZ")
        countryView.configureView(heading: "Search Country",
                                  placeHolder: "Please Enter Country")
        bankView.configureView(heading: "Search Bank",
                               placeHolder: "Enter Bank")
        locationView.configureView(heading: "Search Location",
                                   placeHolder: "Please Enter Location")
        
        //Adding Filter Button
        searchButton.setTitle(" Filter", for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        searchButton.setTitleColor(.black, for: .normal)
        
        self.navigationController?.navigationBar.tintColor = .black
        
        AddSubviews()
        
    }
    
    private func layoutUI() {
        
        view.addSubview(containerStackView)
        
        //Stack View
        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            make.bottom.equalTo(view.safeAreaInsets.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        searchButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
        }
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.autoresizesSubviews = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = 20
        
    }
    
    private func AddSubviews() {
        containerStackView.addArrangedSubview(blzView)
        containerStackView.addArrangedSubview(countryView)
        containerStackView.addArrangedSubview(bankView)
        containerStackView.addArrangedSubview(locationView)
        containerStackView.addArrangedSubview(searchButton)
        containerStackView.addArrangedSubview(spacerView)
        
        view.addGestureRecognizer(tapBackground)
    }
    
    private func setupBindings() {
        
        tapBackground.rx.event
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap.bind { [weak self] _ in
            guard let self = self else {return}
            let searchModel = FilterModel(blz: self.blzView.text,
                                          countryCode: self.countryView.text,
                                          location: self.locationView.text,
                                          bank: self.bankView.text)
            self.viewModel.searchSelected.onNext(searchModel)
        }
        .disposed(by: disposeBag)
    }
}
