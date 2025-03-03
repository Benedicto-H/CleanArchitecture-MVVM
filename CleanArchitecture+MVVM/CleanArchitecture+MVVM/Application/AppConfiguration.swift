//
//  AppConfiguration.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 3/3/25.
//

import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: URL = URL(string: "https://api.github.com")!
    
    /// Ideally this parameter should be moved into remote config, or receive it in keep alive cache police in header
    let trendingRepositoriesCacheMaxAliveTimeInSeconds: TimeInterval = 24 * 60 * 60
    
    /// if false it does not print logs if true it prints logs in debug mode only
    let shouldLogNetworkRequests = false
}
