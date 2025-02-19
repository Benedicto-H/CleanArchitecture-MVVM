//
//  TrendingRepositoriesPageDto.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

struct TrendingRepositoriesPageDto: Decodable {
    let items: [RepositoryDto]
}

extension TrendingRepositoriesPageDto {
    func toDomain() -> TrendingRepositoriesPage {
        return TrendingRepositoriesPage(items: items.map({ $0.toDomain() }))
    }
}
