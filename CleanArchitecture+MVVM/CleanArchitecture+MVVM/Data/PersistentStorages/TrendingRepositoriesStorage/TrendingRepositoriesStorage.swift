//
//  TrendingRepositoriesStorage.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

enum TrendingRepositoriesStorageItem {
    
    case upToDate(TrendingRepositoriesPageDto)
    case outdated(TrendingRepositoriesPageDto)
}

protocol TrendingRepositoriesStorage {
    
    func getTrendingRepositoriesPageDto(completion: @escaping (Result<TrendingRepositoriesStorageItem?, Error>) -> Void) -> Void
    func save(trendingRepositoriesPageDto: TrendingRepositoriesPageDto) -> Void
}
