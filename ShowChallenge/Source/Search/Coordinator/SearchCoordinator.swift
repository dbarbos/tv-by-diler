//
//  SearchCoordinator.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import Foundation
import UIKit

protocol SearchCoordinatorProtocol: Coordinator {
    func showSearchViewController()
    func loadShowDetailCoordinator(for tvShow: TVShow)
    func loadSArtistDetailCoordinator(for artist: ArtistDetail)
}

class SearchCoordinator: SearchCoordinatorProtocol {
    
    
    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .search }
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSearchViewController()
    }
    
    func showSearchViewController() {
        let searchViewController = SearchViewController.instantiate()
        
        searchViewController.coordinator = self
        
        searchViewController.didCallEvent = { [weak self] event in
            switch event {
            case .showDetail(let show):
                self?.loadShowDetailCoordinator(for: show)
            case .artistDetail(let artist):
                self?.loadSArtistDetailCoordinator(for: artist)
            }
        }
        
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func loadShowDetailCoordinator(for tvShow: TVShow) {
        let showDetailCoordinator = ShowDetailCoordinator(navigationController, data: tvShow)
        showDetailCoordinator.start()
        childCoordinators.append(showDetailCoordinator)
    }
    
    func loadSArtistDetailCoordinator(for artist: ArtistDetail) {
        let artistDetailCoordinator = ArtistDetailsCoordinator(navigationController, data: artist)
        artistDetailCoordinator.start()
        childCoordinators.append(artistDetailCoordinator)
    }
    
}
