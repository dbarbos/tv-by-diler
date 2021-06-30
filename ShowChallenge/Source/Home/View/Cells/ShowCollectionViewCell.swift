//
//  ShowCollectionViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation
import UIKit
import SDWebImage

class ShowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterShadowView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var showDescription: UILabel!
    
    func setup(tvShow: TVShow) {
        titleLabel.text = tvShow.name
        
        if let summary = tvShow.summary {
            showDescription.attributedText = summary.asHtmlAttributed(color: UIColor(named: "CustomDarkGray") ?? UIColor.darkGray)
        } else {
            showDescription.text = "No summary available"
        }
       
        posterShadowView.applyShadow(cornerRadius: posterImageView.layer.cornerRadius)
        
        guard let imageUrl = tvShow.image?.medium else { return }
        
        posterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"), options: [], context: nil)
        
    }
    
}
