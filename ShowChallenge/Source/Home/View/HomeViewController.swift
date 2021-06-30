//
//  HomeViewController.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import UIKit

// MARK: - Class
class HomeViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    
    var didCallEvent: ((HomeViewController.Event) -> Void)?
    
    var viewModel = HomeViewModel()
    
    var coordinator: HomeCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shows"
        
        viewModel.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        viewModel.fetchTvShows(page: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.subviews.first?.alpha = 1
    }
}

// MARK: - Extensions
extension HomeViewController {
    enum Event {
        case showDetail(show: TVShow)
    }
}

// MARK: - Extensions HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didUpdateTvShowsList() {
        collectionView.reloadData()
    }
}

// MARK: - Extensions UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != viewModel.tvShows.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCollectionViewCell", for: indexPath) as! ShowCollectionViewCell
            
            cell.setup(tvShow: viewModel.tvShows[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingShowCollectionViewCell", for: indexPath) as! LoadingShowCollectionViewCell
            cell.setup()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tvShows.count > 0 ? viewModel.tvShows.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didCallEvent?(.showDetail(show: viewModel.tvShows[indexPath.row]))
    }
    
}

// MARK: - Extensions UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width / 2) - 6
        
        return CGSize(width: width, height: width * 2.1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Extensions UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == viewModel.tvShows.count && indexPath.row > 0 {
            guard let lastShow = viewModel.tvShows.last else { return }
            viewModel.fetchTvShows(page: lastShow.id/250 + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let selectedShow = viewModel.tvShows[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { (actions) -> UIMenu? in
            let share = UIAction(
                title: "Share...",
                image: UIImage(systemName: "square.and.arrow.up"),
                identifier: .none,
                discoverabilityTitle: nil,
                attributes: [],
                state: .off
            ) { (action) in
                let items = ["You have to watch this show! \(selectedShow.name)", selectedShow.url ?? ""]
                self.present(
                    UIActivityViewController(activityItems: items, applicationActivities: nil),
                    animated: true
                )
            }
            
            let isFavorite: Bool = LocalStorageManager.shared.isFavorite(selectedShow.id)
            
            let addToFavorite = UIAction(
                title: isFavorite ? "Remove from Favorite" : "Add to Favorites",
                image: UIImage(systemName: isFavorite ? "minus.circle" : "plus.circle"),
                identifier: nil,
                discoverabilityTitle: nil,
                attributes: [],
                state: .off
            ) { (action) in
                isFavorite
                    ? LocalStorageManager.shared.removeFromFavorite(selectedShow.id)
                    : LocalStorageManager.shared.addToFavorite(show: selectedShow)
                
            }
            return UIMenu(
                title: "",
                image: nil,
                identifier: nil,
                options: [],
                children: [share, addToFavorite]
            )
        }
    }
}
