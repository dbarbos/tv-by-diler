//
//  ArtistViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit
import Combine

// MARK: Protocol

protocol ArtistDetailsViewModelDelegate: AnyObject {
    func didUpdateShowsList()
}

// MARK: Class

class ArtistDetailsViewModel {
    
    // MARK: Properties
    
    private var showsSubscriber: AnyCancellable?
    
    weak var delegate: ArtistDetailsViewModelDelegate?
    
    let artist: ArtistDetail!
    
    var shows: [TVShow] = []
    
    // MARK: Init
    
    init(artist: ArtistDetail) {
        self.artist = artist
    }
    
    // MARK: Methods
    
    func fetchShows() {
       
        showsSubscriber = APIManager.shared.getShows(for: artist.id)
            .sink(receiveCompletion: { [weak self] (status) in
                switch status {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.delegate?.didUpdateShowsList()
                }
            }, receiveValue: { [weak self] (artistShowsQueryResponse) in
                let mappedResponse = artistShowsQueryResponse.map{ $0._embedded?.show }.filter({ $0 != nil }) as! [TVShow]
                self?.shows = mappedResponse
            })
        
    }

}
