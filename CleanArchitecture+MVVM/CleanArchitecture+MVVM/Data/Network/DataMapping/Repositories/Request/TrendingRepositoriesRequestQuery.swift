//
//  TrendingRepositoriesRequestQuery.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

struct TrendingRepositoriesRequestQuery: Encodable {
    
    let query = "language=+sort:stars"
    
    private enum CodingKeys: String, CodingKey {
        case query = "q"
    }
}
