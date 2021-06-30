//
//  ShowDetailViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import Foundation
import Combine
import UIKit

// MARK: Protocol

protocol ShowDetailViewModelDelegate: AnyObject {
    func didUpdateSeasonsList()
}

// MARK: Class

class ShowDetailViewModel {
    
    // MARK: Properties
    
    private var episodesSubscriber: AnyCancellable?
    
    weak var delegate: ShowDetailViewModelDelegate?
    
    let tvShow: TVShow!
    
    var seasons: [Int: [Episode]] = [:]
    
    var details: String {
       
        var detailText = ""
        
        detailText += genres
        
        if let premiered = tvShow.premiered {
            detailText += " ・ \(premiered)"
        }
        
        if let averageRuntime = tvShow.averageRuntime {
            detailText += " ・ \(averageRuntime) min"
        }
        
        return detailText
        
    }
    
    var genres: String {
        if let genres = tvShow.genres {
            return genres.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
        } else {
            return "TV Show"
        }
    }
    
    var weekDays: String {
        if let weekDays = tvShow.schedule?.days {
            return weekDays.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
        } else {
            return "not available"
        }
    }
    
    // MARK: Init
    
    init(tvShow: TVShow) {
        self.tvShow = tvShow
    }
    
    // MARK: Methods
    
    func ratingColor() -> UIColor {
        guard let rating = tvShow.rating?.average else { return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) }
        
        switch rating {
        case 0...4.9:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case 5...7.9:
            return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case 8...10:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        default:
            return UIColor.black
        }
    }
    
    
    
    func fetchEpisodes() {
        
        episodesSubscriber = APIManager.shared.getEpisodes(showId: tvShow.id)
            .sink(receiveCompletion: { [weak self] (status) in
                switch status {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.delegate?.didUpdateSeasonsList()
                }
            }, receiveValue: { [weak self] (episodes) in
                let groupedEpisodes = Dictionary(grouping: episodes, by: \.season)
                self?.seasons = groupedEpisodes
            })
        
    }
    
}
