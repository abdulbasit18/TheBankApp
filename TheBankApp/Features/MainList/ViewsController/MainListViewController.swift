//
//  MainListViewController.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 31/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MainListViewController: BaseViewController {
    
    // MARK: - UI
    private let tableView = UITableView()
    private let indicator = UIActivityIndicatorView()
    private var filterBarButton: UIBarButtonItem?
    private var validationBarButton: UIBarButtonItem?
    
    // MARK: - Properties
    private let viewModel: MainListViewModelType
    private let disposeBag = DisposeBag()
    private var isBindingUpdated: Bool = false
    
    // MARK: - Init
    init(_ viewModel: MainListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        
        //Inform View Model that View is Loaded
        viewModel.inputs.viewDidLoadSubject.onNext(nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        if !isBindingUpdated {
            isBindingUpdated.toggle()
            setupBindings()
        }
    }
    // MARK: - Functions
    
    private func setupUI() {
        
        //Table View Configuration
        tableView.register(BicsTableViewCell.self, forCellReuseIdentifier: BicsTableViewCell.identifier)
        tableView.rowHeight = 80
        tableView.dataSource = nil
        tableView.delegate = nil
        view.addSubview(tableView)
        
        // Title View Setup
        view.backgroundColor = .white
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "Alzura"
        let imageV = UIImageView()
        imageV.image = UIImage(named: "logo")
        
        stackView.addArrangedSubview(imageV)
        stackView.addArrangedSubview(label)
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        navigationItem.titleView = stackView
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Right Bar Item Setup
        filterBarButton = UIBarButtonItem(image: UIImage(named: "filter")?.withRenderingMode(.alwaysOriginal),
                                          style: .plain,
                                          target: self,
                                          action: nil)
        navigationItem.rightBarButtonItem = filterBarButton
        
        //Left Bar Item Setup
        validationBarButton = UIBarButtonItem(image: UIImage(named: "validation")?.withRenderingMode(.alwaysOriginal),
                                              style: .plain,
                                              target: self,
                                              action: nil)
        navigationItem.leftBarButtonItem = validationBarButton
        
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //Indicator Setup
        view.addSubview(indicator)
        indicator.color = .black
        indicator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        setupUIBindings()
    }
    
    private func setupUIBindings() {
        
        // Load Table View Data by ViewModel SourceData Object
        viewModel.outputs.sourceData
            .bind(to: self.tableView.rx.items(cellIdentifier: BicsTableViewCell.identifier)) { _, model, cell in
                let cell = cell as? BicsTableViewCell
                cell?.configureWith(model)
        }.disposed(by: self.disposeBag)
        
        // Notify ViewModel Scroll is Reached to an End
        tableView.rx.reachedBottom
            .bind(to: viewModel.inputs.reachedBottomSubject)
            .disposed(by: disposeBag)
        
        /*
         Shred Loading Subject which will update the
         Main screen Loader and Bottom Pagination Loader
         */
        let sharedLoadingSubject = viewModel.outputs.isLoadingSubject.share()
        
        sharedLoadingSubject
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        sharedLoadingSubject.subscribe(onNext: { [weak self] (isAnimating) in
            guard let self = self else {return}
            if self.tableView.visibleCells.isEmpty {
                isAnimating ? self.startAnimating() : self.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        // Notify ViewModel That Search Button is Tapped
        filterBarButton?.rx.tap
            .bind(to: viewModel.inputs.searchActionSubject)
            .disposed(by: disposeBag)
        
        // Notify ViewModel That Validation Button is Tapped
        validationBarButton?.rx.tap
            .bind(to: viewModel.inputs.validationSelectedSubject)
            .disposed(by: disposeBag)
        
        // Show Alert on Error
        viewModel.outputs.errorSubject
            .subscribe(onNext: { [weak self] (errorString) in
                self?.showAlert(with: "Error", and: errorString)
            }).disposed(by: disposeBag)
    }
}
