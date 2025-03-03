//
//  AppDIContainer.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 3/3/25.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferServiceProvider = {
        let config = ApiDataNetworkConfig(baseURL: appConfiguration.apiBaseURL)
        let apiDataNetwork = NetworkServiceImpl(config: config,
                                                   logger: NetworkLoggerImpl(shouldLogRequests: appConfiguration.shouldLogNetworkRequests))
        
        return DataTransferServiceImpl(with: apiDataNetwork)
    }()
    
    lazy var imagesDataTransferService: DataTransferServiceProvider = {
        let imagesDataNetwork = NetworkServiceImpl(logger: NetworkLoggerImpl(shouldLogRequests: appConfiguration.shouldLogNetworkRequests))
        
        return DataTransferServiceImpl(with: imagesDataNetwork)
    }()
    
    // MARK: - DIContainers of features
    func makeTrendingRepositoriesFeatureDIContainer() -> TrendingRepositoriesFeatureDIContainer {
        let dependencies = TrendingRepositoriesFeatureDIContainer.Dependencies(apiDataTransferService: apiDataTransferService,
                                                                               imagesDataTransferService: imagesDataTransferService,
                                                                               appConfiguration: appConfiguration)
        
        return TrendingRepositoriesFeatureDIContainer(dependencies: dependencies)
    }
}
