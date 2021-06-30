//
//  ArtistDetailsCoordinator.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit

// MARK: Protocol

protocol ArtistDetailsCoordinatorProtocol: Coordinator {
    func showArtistDetailsViewController()
}

// MARK: Class

class ArtistDetailsCoordinator: ArtistDetailsCoordinatorProtocol {
    
    // MARK: Properties
    
    var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .artistDetail }
    
    var data: Any?
    
    // MARK: Init
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
        self.data = data
    }
    
    // MARK: Methods
    
    func start() {
        showArtistDetailsViewController()
    }
    
    func showArtistDetailsViewController() {
        
        guard let artist = data as? ArtistDetail else { return }
        let viewModel = ArtistDetailsViewModel(artist: artist)
        
        let viewController = ArtistDetailsViewController.instantiate()
        
        viewController.viewModel = viewModel
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
