//
//  LoginCoordinator.swift
//  Challenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import Foundation
import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showLoginViewController()
}

class LoginCoordinator: LoginCoordinatorProtocol {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var flow: CoordinatorFlow { .login }
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginViewController()
    }
    
    func showLoginViewController() {
        let loginViewController = LoginViewController()
        
        loginViewController.didCallEvent = { [weak self] event in
            self?.finish()
        }
        
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    deinit {
        print("LoginCoordinator dinited properly")
    }
    
}
