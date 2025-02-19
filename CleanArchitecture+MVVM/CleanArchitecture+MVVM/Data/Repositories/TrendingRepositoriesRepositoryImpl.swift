//
//  DefaultTrendingRepositoriesRepository.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

final class TrendingRepositoriesRepositoryImpl {
    
    private let dataTransferServiceProvider: DataTransferServiceProvider
    private let cache: TrendingRepositoriesStorage
    
    init(dataTransferService: DataTransferServiceProvider,
         cache: TrendingRepositoriesStorage) {
        
        self.dataTransferServiceProvider = dataTransferService
        self.cache = cache
    }
}

extension TrendingRepositoriesRepositoryImpl: TrendingRepositoriesRepository {
    func fetchTrendingRepositoriesList(cached: @escaping (TrendingRepositoriesPage) -> Void, completion: @escaping (Result<TrendingRepositoriesPage, any Error>) -> Void) -> (any Cancellable)? {
        
        let task = RepositoryTask()
        
        cache.getTrendingRepositoriesPageDto { [cache, dataTransferServiceProvider] cacheResult in
            
            let shouldFetchData: Bool
            
            if case let .success(value) = cacheResult {
                switch value {
                case .upToDate(let pageDto):
                    cached(pageDto.toDomain())
                    completion(.success(pageDto.toDomain()))
                    shouldFetchData = false
                case .outdated(let pageDto):
                    cached(pageDto.toDomain())
                    shouldFetchData = true
                case .none:
                    shouldFetchData = true
                }
            } else {
                shouldFetchData = true
            }
            
            /// fetch new data if cache is outdated or nil
            guard shouldFetchData, !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getTrendingRepositories(requestQuery: TrendingRepositoriesRequestQuery())
            
            task.networkTask = dataTransferServiceProvider.request(with: endpoint, completion: { result in
                switch result {
                case .success(let trendingRepositoriesPageDto):
                    cache.save(trendingRepositoriesPageDto: trendingRepositoriesPageDto)
                    
                    let trendingRepositoriesPage = trendingRepositoriesPageDto.toDomain()   //  page
                    completion(.success(trendingRepositoriesPage))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        
        return task
    }
}
