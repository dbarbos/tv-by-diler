//
//  HomeCoordinator.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import Foundation
import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    func showHomeViewController()
    func loadShowDetailCoordinator(for tvShow: TVShow)
}

class HomeCoordinator: HomeCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .show }
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHomeViewController()
    }
    
    func showHomeViewController() {
        let homeViewController = HomeViewController.instantiate()
        homeViewController.coordinator = self
        
        homeViewController.didCallEvent = { [weak self] event in
            switch event {
            case .showDetail(let show):
                self?.loadShowDetailCoordinator(for: show)
            }
        }
        
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    func loadShowDetailCoordinator(for tvShow: TVShow) {
        let showDetailCoordinator = ShowDetailCoordinator(navigationController, data: tvShow)
        showDetailCoordinator.start()
        childCoordinators.append(showDetailCoordinator)
    }
}
