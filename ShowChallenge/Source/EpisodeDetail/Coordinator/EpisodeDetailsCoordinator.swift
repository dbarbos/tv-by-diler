//
//  EpisodeDetailsCoordinator.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit

// MARK: Protocol

protocol EpisodeDetailsCoordinatorProtocol: Coordinator {
    func showEpisodeDetailsViewController()
}

// MARK: Class

class EpisodeDetailsCoordinator: EpisodeDetailsCoordinatorProtocol {
    
    // MARK: Properties
    
    var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .episodeDetail }
    
    var data: Any?
    
    // MARK: Init
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
        self.data = data
    }
    
    // MARK: Methods
    
    func start() {
        showEpisodeDetailsViewController()
    }
    
    func showEpisodeDetailsViewController() {
        guard let episode = data as? Episode else { return }
        let viewModel = EpisodeDetailsViewModel(episode: episode)
        
        let viewController = EpisodeDetailsViewController.instantiate()
        
        viewController.viewModel = viewModel
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
