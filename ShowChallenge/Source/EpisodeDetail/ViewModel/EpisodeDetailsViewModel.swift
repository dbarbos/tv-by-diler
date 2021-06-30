//
//  EpisodeDetailsViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit

// MARK: Protocol

protocol EpisodeDetailsViewModelDelegate: AnyObject {
    
}

// MARK: Class

class EpisodeDetailsViewModel {
    
    // MARK: Properties
    
    weak var delegate: EpisodeDetailsViewModelDelegate?
    
    let episode: Episode!
    
    var details: String {
        return "T\(episode.season), E\(episode.number)・\(episode.airdate ?? "")・\(episode.runtime ?? 0) min"
    }
    
    // MARK: Init
    
    init(episode: Episode) {
        self.episode = episode
    }
    
}
