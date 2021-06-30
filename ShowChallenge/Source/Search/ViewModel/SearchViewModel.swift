//
//  SearchViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import Foundation
import Combine

protocol SearchViewModelDelegate: AnyObject {
    func didUpdateSearchList()
    func didBeginLoadingData()
    func didFinishLoadingData()
}

class SearchViewModel {
    
    private var searchSubscriber: AnyCancellable?
    private var searchPeopleSubscriber: AnyCancellable?
    
    private var isWaiting: Bool = false
    private var searchTimerDelay: Timer?
    private var currentQuery: String = ""
    
    weak var delegate: SearchViewModelDelegate?
    
    enum SearchScopes {
        case all, shows, artists
    }
    
    var selectedScope: SearchScopes = .all {
        didSet {
            delegate?.didUpdateSearchList()
        }
    }
    
    var tvShows: [TVShow] = [] {
        didSet {
            delegate?.didUpdateSearchList()
        }
    }
    
    var artists: [ArtistDetail] = [] {
        didSet {
            delegate?.didUpdateSearchList()
        }
    }
    
    func setSelectedScope(for index: Int) {
        switch index {
        case 0:
            selectedScope = .all
        case 1:
            selectedScope = .shows
        case 2:
            selectedScope = .artists
        default:
            selectedScope = .all
        }
    }
    
    func fetchData(query: String) {
        
        if query == currentQuery {
            return
        } else {
            currentQuery = query
        }
        
        searchTimerDelay?.invalidate()
        
        if isWaiting { return }
        
        tvShows.removeAll()
        artists.removeAll()
        
        if query.count < 3 {
            delegate?.didFinishLoadingData()
            return
        }
        
        delegate?.didBeginLoadingData()
        
        searchTimerDelay = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(performDataFetch(sender:)), userInfo: query, repeats: false)
    
    }
    
    @objc func performDataFetch(sender: Timer) {
        guard let query: String = sender.userInfo as? String else { return }
        
        isWaiting = true
        
        searchSubscriber = APIManager.shared.getShows(using: query)
            .sink(receiveCompletion: { [weak self] (status) in
                switch status {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.isWaiting = false
                    self?.delegate?.didFinishLoadingData()
            }
        }, receiveValue: { [weak self] (tvShowQueryResult) in
            self?.tvShows = tvShowQueryResult.map { $0.show }
        })
        
        searchPeopleSubscriber = APIManager.shared.getArtists(using: query)
            .sink(receiveCompletion: { [weak self] (status) in
                switch status {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.isWaiting = false
                    self?.delegate?.didFinishLoadingData()
            }
        }, receiveValue: { [weak self] (artistQueryResult) in
            self?.artists = artistQueryResult.map { $0.person }
        })
        
    }
    
}
