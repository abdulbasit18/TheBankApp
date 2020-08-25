//
//  MainController.swift
//  TheBankApp
//
//  Created by Abdul Basit on 10/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MainController: BaseViewController {
    
    // MARK: - UI
    
    private let tableView = UITableView()
    private let indicator = UIActivityIndicatorView()
    private var filterBarButton: UIBarButtonItem?
    private var validationBarButton: UIBarButtonItem?
    private var isBindingUpdated: Bool = false
    
    // MARK: - Properties
    
    let viewModel: MainViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(_ viewModel: MainViewModelType) {
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
        
    }
    
    override func viewDidLayoutSubviews() {
        if !isBindingUpdated {
            isBindingUpdated.toggle()
            setupBindings()
        }
    }
    // MARK: - Functions
    
    private func setupUI() {
        
        tableView.register(BicsTableViewCell.self, forCellReuseIdentifier: "SearchBic")
        tableView.rowHeight = 80
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
    
    private func setupBindings() {
        setupUIBindings()
    }
    
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
    
    private func setupUIBindings() {
        
        // Bind ViewModel Inputs
        tableView.dataSource = nil
        tableView.delegate = nil

        viewModel.outputs.sourceData.asObservable()
            .bind(to: self.tableView.rx.items) { _, _, model in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchBic") as? BicsTableViewCell
                cell?.configureWith(model)
                return cell ?? UITableViewCell()
        }.disposed(by: self.disposeBag)
        
        tableView.rx.reachedBottom.asObservable()
            .bind(to: viewModel.inputs.reachedBottomSubject)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingSubject
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingSubject.subscribe { [weak self] (event) in
            guard let self = self else {return}
            if self.tableView.visibleCells.isEmpty {
                (event.element ?? false) ? self.startAnimating() : self.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        filterBarButton?.rx.tap
            .bind {[weak self] in
                self?.viewModel.inputs.searchActionSubject.onNext(0)}
            .disposed(by: disposeBag)
        
        validationBarButton?.rx.tap
            .bind {[weak self] in
                self?.viewModel.inputs.validationSelectedSubject.onNext(0)}
            .disposed(by: disposeBag)
        
        viewModel.inputs.searchSubject.onNext(FilterModel())
        
        viewModel.outputs.errorSubject
            .subscribe(onNext: { [weak self] (errorString) in
                self?.showAlert(with: "Error", and: errorString)
            }).disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: UIScrollView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else { return Observable.empty() }
                
                let visibleHeight = scrollView.frame.height -
                    scrollView.contentInset.top -
                    scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
        }
        return ControlEvent(events: observable)
    }
}
