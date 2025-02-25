//
//  TrendingRepositoriesListContentViewModel.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/21/25.
//

import Foundation

enum TrendingRepositoriesListContentViewModel: Hashable {
    
    case items([TrendingRepositoriesListItemViewModel])
    case emptyData
    case loading
}
