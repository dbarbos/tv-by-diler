//
//  Coordinator.swift
//  Challenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import UIKit

enum CoordinatorFlow {
    case login, tab, app
    case show, artist, favorite, search, more
    case showDetail, episodeDetail, artistDetail
}

// MARK: - Coordinator Delegate
protocol CoordinatorDelegate: class {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

// MARK: - Coordinator Pattern Protocol
protocol Coordinator: class {
    
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var flow: CoordinatorFlow { get }
    
    func start()
    func finish()
    
    init(_ navigationController: UINavigationController, data: Any?)
    
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
