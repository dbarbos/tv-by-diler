//
//  FavoriteShowTableViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import UIKit

class FavoriteShowTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterShadowView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    func setup(show: Favorite) {
        nameLabel.text = show.name
        
        if let summary = show.summary {
            summaryLabel.attributedText = summary.asHtmlAttributed(color: UIColor(named: "CustomDarkGray") ?? UIColor.darkGray)
        } else {
            summaryLabel.text = "No summary available"
        }
       
        posterShadowView.applyShadow(cornerRadius: posterImageView.layer.cornerRadius)
        
        guard let imageUrl = show.posterUrl else { return }
        
        posterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"), options: [], context: nil)
        
    }
    
}
