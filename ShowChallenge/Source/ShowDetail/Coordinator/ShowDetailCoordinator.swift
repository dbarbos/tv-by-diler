//
//  ShowDetailCoordinator.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import Foundation
import UIKit

protocol ShowDetailCoordinatorProtocol: Coordinator {
    func showShowDetailViewController()
    func loadEpisodeDetailsCoordinator(for episode: Episode)
}

class ShowDetailCoordinator: ShowDetailCoordinatorProtocol {
    
    
    var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .showDetail }
    
    var data: Any?
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
        self.data = data
    }
    
    func start() {
        showShowDetailViewController()
    }
    
    func showShowDetailViewController() {
        
        guard let tvShow = data as? TVShow else { return }
        let viewModel = ShowDetailViewModel(tvShow: tvShow)
        
        let viewController = ShowDetailViewController.instantiate()
        
        viewController.viewModel = viewModel
        viewController.coordinator = self
        
        viewController.didCallEvent = { [weak self] event in
            switch event {
            case .showDetail(let episode):
                self?.loadEpisodeDetailsCoordinator(for: episode)
            }
        }
    
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func loadEpisodeDetailsCoordinator(for episode: Episode) {
        let episodeDetailsCoordinator = EpisodeDetailsCoordinator(navigationController, data: episode)
        episodeDetailsCoordinator.start()
        childCoordinators.append(episodeDetailsCoordinator)
    }
    
}
