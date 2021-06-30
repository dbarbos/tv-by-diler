//
//  AppCoordinator.swift
//  Challenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import Foundation
import UIKit

// MARK: - Protocols
protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}

// MARK: - Class
class AppCoordinator: AppCoordinatorProtocol {
    
    
    // MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .app }
    
    // MARK: - Init
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Methods
    
    func start() {
        showLoginFlow()
    }
    
    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController, data: nil)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator(navigationController, data: nil)
        tabCoordinator.delegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }

}

// MARK: - Extensions
extension AppCoordinator: CoordinatorDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.flow != childCoordinator.flow
        }
        
        switch childCoordinator.flow {
        case .tab:
            navigationController.viewControllers.removeAll()
            showLoginFlow()
        case .login:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        default:
            break
        }
        
    }
    
}
