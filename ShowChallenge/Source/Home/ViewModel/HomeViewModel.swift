//
//  HomeViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation
import Combine

protocol HomeViewModelDelegate: AnyObject {
    func didUpdateTvShowsList()
}

class HomeViewModel {
    
    private var tvShowsSubscriber: AnyCancellable?
        
    private var isWaiting: Bool = false
    
    weak var delegate: HomeViewModelDelegate?
    
    var tvShows: [TVShow] = [] {
        didSet {
            delegate?.didUpdateTvShowsList()
        }
    }
    
    func fetchTvShows(page: Int) {
        
        if isWaiting { return }
        
        isWaiting = true
        
        tvShowsSubscriber = APIManager.shared.getShows(from: page)
            .sink(receiveCompletion: { [weak self] (status) in
                switch status {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.isWaiting = false
                }
            }, receiveValue: { [weak self] (tvShows) in
                self?.tvShows.append(contentsOf: tvShows)
            })
    }
    
}
