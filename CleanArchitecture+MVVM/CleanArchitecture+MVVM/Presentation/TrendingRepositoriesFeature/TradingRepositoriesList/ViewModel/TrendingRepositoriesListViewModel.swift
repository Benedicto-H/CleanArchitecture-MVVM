//
//  TrendingRepositoriesListViewModel.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/21/25.
//

import Foundation

protocol TrendingRepositoriesListViewModelInput {
    
    func viewDidLoad() -> Void
    func viewDidRefresh() -> Void
    func viewDidSelectItem(at index: Int) -> Void
}

protocol TrendingRepositoriesListViewModelOutput {
    
    var content: Observable<TrendingRepositoriesListContentViewModel> { get }
    var error: Observable<String> { get }
}

typealias TrendingRepositoriesListViewModel = TrendingRepositoriesListViewModelInput & TrendingRepositoriesListViewModelOutput

final class TrendingRepositoriesListViewModelImpl: TrendingRepositoriesListViewModel {
    
    private let fetchTrendingRepositoriesUseCase: FetchTrendingRepositoriesUseCase
    
    private(set) var items = [TrendingRepositoriesListItemViewModel]()
    private var dataLoadTask: Cancellable? {
        willSet { dataLoadTask?.cancel() }
    }
    
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    let content: Observable<TrendingRepositoriesListContentViewModel> = Observable(.emptyData)
    let error: Observable<String> = Observable("")
    
    // MARK: - Init
    init(fetchTrendingRepositoriesUseCase: FetchTrendingRepositoriesUseCase,
         mainQueue: DispatchQueueType) {
        
        self.fetchTrendingRepositoriesUseCase = fetchTrendingRepositoriesUseCase
        self.mainQueue = mainQueue
    }
    
    // MARK: - Private
    private func reload() -> Void {
        
        resetData()
        loadData()
    }
    
    private func resetData() -> Void {
        
        items.removeAll()
        content.value = .emptyData
    }
    
    private func loadData() -> Void {
        
        content.value = .loading
        
        dataLoadTask = fetchTrendingRepositoriesUseCase.fetch(cached: { [weak self] page in
            self?.mainQueue.async {
                self?.update(page.items)
            }
        }, completion: { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let page):
                    self?.update(page.items)
                case .failure(let error):
                    self?.updateContent()
                }
            }
        })
    }
    
    private func update(_ repositories: [Repository]) -> Void {
        
        items = repositories.map { TrendingRepositoriesListItemViewModel(repository: $0) }
        updateContent()
    }
    
    private func updateContent() -> Void {
        content.value = items.isEmpty ? .emptyData : .items(items)
    }
    
    private func handle(error: Error) -> Void {
        
        switch error.uiError {
        case .notConnectedToInternet:
            self.error.value = NSLocalizedString(Localizations.Common.Errors.noInternetConnection, comment: "")
        case .cancelled: return
        case .generic:
            self.error.value = NSLocalizedString(Localizations.TrendingRepositoriesFeature.TrendingRepositoriesList.Errors.failedLoadingRepositoriesTitle, comment: "")
        }
    }
}

extension TrendingRepositoriesListViewModelImpl {
    
    func viewDidLoad() {
        reload()
    }
    
    func viewDidRefresh() {
        reload()
    }
    
    func viewDidSelectItem(at index: Int) {
        
        guard case .items = content.value else { return }
        var item = items[index]
        
        item.isExpanded.toggle()
        items[index] = item
        
        content.value = .items(items)
    }
}
