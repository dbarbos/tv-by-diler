//
//  FavoriteCoordinator.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit

// MARK: Protocol

protocol FavoriteCoordinatorProtocol: Coordinator {
    func showFavoriteViewController()
    func loadShowDetailCoordinator(for tvShow: TVShow)
}

// MARK: Class

class FavoriteCoordinator: FavoriteCoordinatorProtocol {
    
    // MARK: Properties
    
    var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .favorite }
    
    // MARK: Init
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
    }
    
    // MARK: Methods
    
    func start() {
        showFavoriteViewController()
    }
    
    func showFavoriteViewController() {
        
        let viewController = FavoriteViewController.instantiate()
        
        viewController.coordinator = self
        
        viewController.didCallEvent = { [weak self] event in
            switch event {
            case .showDetail(let show):
                self?.loadShowDetailCoordinator(for: show)
            }
        }
        
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
    func loadShowDetailCoordinator(for tvShow: TVShow) {
        let showDetailCoordinator = ShowDetailCoordinator(navigationController, data: tvShow)
        showDetailCoordinator.start()
        childCoordinators.append(showDetailCoordinator)
    }
    
}
