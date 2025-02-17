//
//  TrendingRepositoriesRepository.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

protocol TrendingRepositoriesRepository {
    /// DataSource와의 상호작용
    @discardableResult
    func fetchTrendingRepositoriesList(cached: @escaping (TrendingRepositoriesPage) -> Void,
                                       completion: @escaping (Result<TrendingRepositoriesPage, Error>) -> Void) -> Cancellable?
}
