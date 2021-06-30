//
//  TabCoordinator.swift
//  Challenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import Foundation
import UIKit

enum TabBarPage {
    case home
    case person
    case favorite
    case search
    case more
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .person
        case 2:
            self = .favorite
        case 3:
            self = .search
        case 4:
            self = .more
        default:
            return nil
        }
    }
    
    func title() -> String {
        switch self {
        case .home:
            return "Shows"
        case .person:
            return "Artist"
        case .favorite:
            return "Favorite"
        case .search:
            return "Search"
        case .more:
            return "About"
        }
    }
    
    func index() -> Int {
        switch self {
        case .home:
            return 0
        case .person:
            return 1
        case .favorite:
            return 2
        case .search:
            return 3
        case .more:
            return 4
        }
    }
    
    func icon() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "tv.fill")
        case .person:
            return UIImage(systemName: "person.crop.rectangle.fill")
        case .favorite:
            return UIImage(systemName: "star.square.fill")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .more:
            return UIImage(systemName: "ellipsis.circle.fill")
        }
    }
}

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    func selectIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabCoordinator: NSObject, TabCoordinatorProtocol {
        
    var tabBarController: UITabBarController
    
    weak var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var flow: CoordinatorFlow { .tab }
    
    required init(_ navigationController: UINavigationController, data: Any?) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        let pages: [TabBarPage] = [
            .home,
            .favorite,
            .search,
        ].sorted(by: { $0.index() < $1.index() })
        
        let controllers: [UINavigationController] = pages.map { getTabController($0) }
        
        loadTabBarController(with: controllers)
    }
    
    private func loadTabBarController(with controllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(controllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.index()
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        
        let pageNavigationController = UINavigationController()
        pageNavigationController.setNavigationBarHidden(false, animated: false)
        pageNavigationController.navigationBar.prefersLargeTitles = true
        
        pageNavigationController.tabBarItem = UITabBarItem(
            title: page.title(),
            image: page.icon(),
            tag: page.index()
        )
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(pageNavigationController, data: nil)
            homeCoordinator.start()
        case .search:
            let searchCoordinator = SearchCoordinator(pageNavigationController, data: nil)
            searchCoordinator.start()
        case .favorite:
            let favoriteCoordinator = FavoriteCoordinator(pageNavigationController, data: nil)
            favoriteCoordinator.start()
        default:
            break
        }
        
        return pageNavigationController
        
    }
    
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.index()
    }
    
    func selectIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.index()
    }
    
    func currentPage() -> TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }
        
    deinit {
        print("TabCoordinator deinited properly")
    }
    
}

extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // do something maybe?
    }
}
