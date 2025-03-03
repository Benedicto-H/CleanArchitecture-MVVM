//
//  TrendingRepositoriesListViewController.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/25/25.
//

import UIKit

final class TrendingRepositoriesListViewController: UIViewController {

    private var viewModel: TrendingRepositoriesListViewModel
    private let imagesRepository: ImagesRepository
    private lazy var itemsTableViewController = TrendingRepositoriesListTableViewController(viewModel: viewModel,
                                                                                            imagesRepository: imagesRepository)
    
    // MARK: - Lifecycle
    init(viewModel: TrendingRepositoriesListViewModel, imagesRepository: ImagesRepository) {
        self.viewModel = viewModel
        self.imagesRepository = imagesRepository
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLocalizations()
        setupViewLayout()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private
    private func setupLocalizations() -> Void {
        self.title = NSLocalizedString(Localizations.TrendingRepositoriesFeature.TrendingRepositoriesList.ListScreen.title, comment: "")
    }
    
    private func setupViewLayout() -> Void {
        add(child: itemsTableViewController, container: view)
    }
    
    private func bind(to viewModel: TrendingRepositoriesListViewModel) -> Void {
        
        viewModel.content.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func updateItems() -> Void {
        itemsTableViewController.reload()
    }
    
    private func showError(_ error: String) -> Void {
        
        guard !error.isEmpty else { return }
        
        let alert = UIAlertController(title: NSLocalizedString(Localizations.Common.Errors.errorTitle,
                                                               comment: ""),
            message: error,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(Localizations.Common.Errors.okButtonTitle,
                                                               comment: ""),
                style: UIAlertAction.Style.default,
                handler: nil)
        )
        
        present(alert, animated: true)
    }


}
