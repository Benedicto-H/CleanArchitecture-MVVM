//
//  FetchTrendingRepositoriesUseCase.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

protocol FetchTrendingRepositoriesUseCase: AnyObject {
    /// Business Logic 정의
    func fetch(cached: @escaping (TrendingRepositoriesPage) -> Void, completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void) -> Cancellable?
}

final class FetchTrendingRepositoriesUseCaseImpl: FetchTrendingRepositoriesUseCase {

    private let trendingRepositoriesRepository: TrendingRepositoriesRepository

    init(trendingRepositoriesRepository: TrendingRepositoriesRepository) {
        self.trendingRepositoriesRepository = trendingRepositoriesRepository
    }
}

extension FetchTrendingRepositoriesUseCaseImpl {
    func fetch(cached: @escaping (TrendingRepositoriesPage) -> Void, completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void) -> Cancellable? {
        self.trendingRepositoriesRepository.fetchTrendingRepositoriesList(cached: cached, completion: completion)
    }
}
