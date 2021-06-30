//
//  SearchViewController.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import UIKit

// MARK: - Class
class SearchViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinator: SearchCoordinator?
    
    var didCallEvent: ((SearchViewController.Event) -> Void)?
    
    var viewModel = SearchViewModel()
    let searchController = UISearchController()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        viewModel.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "ShowTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowTableViewCell")
        tableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtistTableViewCell")
        
        initSearchController()
        
    }
    
    // MARK: - Methods
    private func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.scopeButtonTitles = ["All", "Shows", "Artists"]
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
    }
}

// MARK: - Extensions
extension SearchViewController {
    enum Event {
        case showDetail(show: TVShow)
        case artistDetail(artist: ArtistDetail)
    }
}

// MARK: - Extensions SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate {
    
    func didUpdateSearchList() {
        print(viewModel.tvShows)
        tableView.reloadData()
    }
    
    func didBeginLoadingData() {
        activityIndicator.startAnimating()
    }
    
    func didFinishLoadingData() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Extensions UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.selectedScope {
        case .all:
            return section == 0 ? viewModel.tvShows.count : viewModel.artists.count
        case .shows:
            return section == 0 ? viewModel.tvShows.count : 0
        case .artists:
            return section == 0 ? 0 : viewModel.artists.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return indexPath.section == 0 ? loadShowCell(for: indexPath) : loadArtistCell(for: indexPath)
                
    }
    
    func loadShowCell(for indexPath: IndexPath) -> ShowTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTableViewCell") as! ShowTableViewCell
        cell.setup(tvShow: viewModel.tvShows[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func loadArtistCell(for indexPath: IndexPath) -> ArtistTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell") as! ArtistTableViewCell
        cell.setup(artist: viewModel.artists[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexPath.section == 0
            ? didCallEvent?(.showDetail(show: viewModel.tvShows[indexPath.row]))
            : didCallEvent?(.artistDetail(artist: viewModel.artists[indexPath.row]))
        
    }
}

// MARK: - Extensions UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchController.searchBar.text
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.setSelectedScope(for: selectedScope)
    }
}

// MARK: - Extensions UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        viewModel.fetchData(query: searchText)
    }

}
