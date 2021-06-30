//
//  EpisodeCollectionViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import Foundation
import UIKit
import SDWebImage

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterShadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    @IBOutlet weak var episodeSummary: UILabel!
    
    func setup(episode: Episode) {
        
        titleLabel.text = episode.name
        
        episodeLabel.text = "Season \(episode.season)"
        
        if let summary = episode.summary {
            episodeSummary.attributedText = summary.asHtmlAttributed(color: UIColor(named: "CustomDarkGray") ?? UIColor.darkGray)
        } else {
            episodeSummary.text = "No summary available"
        }
       
        posterShadowView.applyShadow(cornerRadius: posterImageView.layer.cornerRadius)
        
        guard let imageUrl = episode.image?.medium else { return }
        
        posterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"), options: [], context: nil)
        
    }
    
}
