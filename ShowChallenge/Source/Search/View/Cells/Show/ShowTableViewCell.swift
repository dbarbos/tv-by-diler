//
//  ShowTableViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterShadowView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    func setup(tvShow: TVShow) {
        
        nameLabel.text = tvShow.name
        
        if let genres = tvShow.genres {
            let genreString = genres.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
            genreLabel.text = genreString
        } else {
            genreLabel.text = "TV Show"
        }
        
        if let summary = tvShow.summary {
            summaryLabel.attributedText = summary.asHtmlAttributed(color: UIColor(named: "CustomDarkGray") ?? UIColor.darkGray)
        } else {
            summaryLabel.text = "No summary available"
        }
       
        posterShadowView.applyShadow(cornerRadius: posterImageView.layer.cornerRadius)
        
        guard let imageUrl = tvShow.image?.medium else { return }
        
        posterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"), options: [], context: nil)
    }
}
