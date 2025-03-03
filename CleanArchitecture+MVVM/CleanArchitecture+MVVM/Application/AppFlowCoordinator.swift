//
//  AppFlowCoordinator.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 3/3/25.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinator]? { get set }
    
    func start() -> Void
}

final class AppFlowCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator]?
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController?,
         childCoordinators: [any Coordinator]? = nil,
         appDIContainer: AppDIContainer) {
        
        self.navigationController = navigationController
        self.childCoordinators = childCoordinators
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        
        let trendingTrendingRepositoriesFeatureDIContainer = appDIContainer.makeTrendingRepositoriesFeatureDIContainer()
        let flow = trendingTrendingRepositoriesFeatureDIContainer.makeTrendingRepositoriesFlowCoordinator(navigationController: navigationController)
        
        flow.start()
    }
}
