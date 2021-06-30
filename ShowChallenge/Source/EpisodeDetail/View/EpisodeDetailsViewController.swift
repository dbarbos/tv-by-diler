//
//  EpisodeDetailsViewController.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import UIKit

// MARK: Class

class EpisodeDetailsViewController: UIViewController, Storyboarded {
    
    // MARK: Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var viewModel: EpisodeDetailsViewModel?
    var coordinator: EpisodeDetailsCoordinator?
 
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadEpisodeData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.subviews.first?.alpha = 100
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: Methods
    
    func loadEpisodeData() {
        guard let viewModel = viewModel else { return }
        
        if let imageUrl = viewModel.episode.image?.original {
            posterImageView.sd_setImage(
                with: URL(string: imageUrl),
                placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"),
                options: [],
                context: nil
            )
        }
        
        episodeNameLabel.text = viewModel.episode.name
        detailsLabel.text = viewModel.details
        summaryLabel.attributedText = viewModel.episode.summary?.asHtmlAttributed(color: .black)
        
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let items = [
            "You have to watch this episode! \(viewModel?.episode.name ?? "")"]
        self.present(
            UIActivityViewController(activityItems: items, applicationActivities: nil),
            animated: true
        )
        
    }
    
}

// MARK: Extensions

extension EpisodeDetailsViewController: EpisodeDetailsViewModelDelegate {
    
}
