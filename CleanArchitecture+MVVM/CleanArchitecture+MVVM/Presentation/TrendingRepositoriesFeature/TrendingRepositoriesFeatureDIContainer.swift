//
//  TrendingRepositoriesFeatureDIContainer.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 3/3/25.
//

import UIKit

final class TrendingRepositoriesFeatureDIContainer: TrendingRepositoriesFlowCoordinatorDependencies {

    struct Dependencies {
        
        let apiDataTransferService: DataTransferServiceProvider
        let imagesDataTransferService: DataTransferServiceProvider
        let appConfiguration: AppConfiguration
    }

    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var trendingRepositoriesCache: TrendingRepositoriesStorage = CoreDataTrendingRepositoriesStorage(currentTime: { Date() },
                                                                                                          config: CoreDataTrendingRepositoriesStorage.Config(maxAliveTimeInSeconds: dependencies.appConfiguration.trendingRepositoriesCacheMaxAliveTimeInSeconds))
    
    lazy var imagesCache: ImagesStorage = CoreDataImagesStorage(currentTime: { Date() })

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases
    func makeFetchTrendingRepositoriesUseCase() -> FetchTrendingRepositoriesUseCase {
        return FetchTrendingRepositoriesUseCaseImpl(trendingRepositoriesRepository: makeTrendingRepositoriesRepository())
    }

    // MARK: - Repositories
    func makeTrendingRepositoriesRepository() -> TrendingRepositoriesRepository {
        return TrendingRepositoriesRepositoryImpl(dataTransferService: dependencies.apiDataTransferService, cache: trendingRepositoriesCache)
    }
    
    func makeImagesRepository() -> ImagesRepository {
        return ImagesRepositoryImpl(dataTransferService: dependencies.imagesDataTransferService, imagesCache: imagesCache)
    }

    // MARK: - Trending Repositories List
    // MARK: - TrendingRepositoriesFlowCoordinatorDependencies
    func makeTrendingRepositoriesListViewController() -> TrendingRepositoriesListViewController {
        return TrendingRepositoriesListViewController(viewModel: makeTrendingRepositoriesListViewModel(), imagesRepository: makeImagesRepository())
    }
    
    func makeTrendingRepositoriesListViewModel() -> TrendingRepositoriesListViewModel {
        return TrendingRepositoriesListViewModelImpl(fetchTrendingRepositoriesUseCase: makeFetchTrendingRepositoriesUseCase(),
                                                        mainQueue: DispatchQueue.main)
    }

    // MARK: - Flow Coordinators
    func makeTrendingRepositoriesFlowCoordinator(navigationController: UINavigationController?) -> TrendingRepositoriesFlowCoordinator {
        return TrendingRepositoriesFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
