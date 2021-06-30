//
//  FavoriteViewController.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListMessageView: UIView!
    @IBOutlet weak var loadingShowDataView: UIView!
    
    var viewModel = FavoriteViewModel()
    var coordinator: FavoriteCoordinator?
    let faroriteCellReuseIdentifier = "FavoriteShowTableViewCell"
    
    var didCallEvent: ((FavoriteViewController.Event) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorite Shows"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.delegate = self
        
        tableView.register(UINib(nibName: faroriteCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: faroriteCellReuseIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFavorite()
        
    }
    
}

extension FavoriteViewController {
    enum Event {
        case showDetail(show: TVShow)
    }
}

extension FavoriteViewController: FavoriteViewModelDelegate {
    func didFinishRequestFetchShow() {
        loadingShowDataView.isHidden = true
    }
    
    func didRequestFetchShow() {
        loadingShowDataView.isHidden = false
    }
    
    func didReceiveShowData(show: TVShow) {
        didCallEvent?(.showDetail(show: show))
    }
    
    func didUpdateFavoriteList() {
        emptyListMessageView.isHidden = !viewModel.favorites.isEmpty
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: faroriteCellReuseIdentifier, for: indexPath) as! FavoriteShowTableViewCell
        
        cell.setup(show: viewModel.favorites[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            LocalStorageManager.shared.removeFromFavorite(viewModel.favorites[indexPath.row])
            viewModel.fetchFavorite()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.fetchShow(showId: Int(viewModel.favorites[indexPath.row].id))
        
    }
    
}
