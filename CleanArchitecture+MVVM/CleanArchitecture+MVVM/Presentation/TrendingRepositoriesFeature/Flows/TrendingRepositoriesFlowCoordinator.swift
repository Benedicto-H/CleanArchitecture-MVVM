//
//  TrendingRepositoriesFlowCoordinator.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 3/3/25.
//

import UIKit

protocol TrendingRepositoriesFlowCoordinatorDependencies {
    func makeTrendingRepositoriesListViewController() -> TrendingRepositoriesListViewController
}

final class TrendingRepositoriesFlowCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var childCoordinators: [any Coordinator]?
    private let dependencies: TrendingRepositoriesFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController?,
         childCoordinators: [any Coordinator]? = nil,
         dependencies: TrendingRepositoriesFlowCoordinatorDependencies) {
        
        self.navigationController = navigationController
        self.childCoordinators = childCoordinators
        self.dependencies = dependencies
    }
    
    func start() {
        
        let viewController = dependencies.makeTrendingRepositoriesListViewController()
        navigationController?.pushViewController(viewController, animated: false)
    }
}
