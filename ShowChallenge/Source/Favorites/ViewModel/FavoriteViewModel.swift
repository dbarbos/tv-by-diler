//
//  FavoriteViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import Combine

// MARK: Protocol

protocol FavoriteViewModelDelegate: AnyObject {
    func didUpdateFavoriteList()
    func didRequestFetchShow()
    func didFinishRequestFetchShow()
    func didReceiveShowData(show: TVShow)
}

// MARK: Class

class FavoriteViewModel {
    
    // MARK: Properties
    
    private var tvShowsSubscriber: AnyCancellable?
    
    weak var delegate: FavoriteViewModelDelegate?
    
    var favorites: [Favorite] = [] {
        didSet {
            delegate?.didUpdateFavoriteList()
        }
    }
    
    // MARK: Methods
    
    func fetchFavorite() {
        
        favorites = LocalStorageManager.shared.getFavorites()
        
    }
    
    func fetchShow(showId: Int) {
        delegate?.didRequestFetchShow()
        
        tvShowsSubscriber = APIManager.shared.getShow(by: showId)
            .sink(receiveCompletion: { [weak self] (status) in
                switch status {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.delegate?.didFinishRequestFetchShow()
                }
            }, receiveValue: { [weak self] (tvShows) in
                self?.delegate?.didReceiveShowData(show: tvShows)
            })
        
        
    }
    
}
