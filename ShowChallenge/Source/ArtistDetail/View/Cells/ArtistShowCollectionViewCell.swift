//
//  ArtistShowCollectionViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit
import SDWebImage

class ArtistShowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterShadowView: UIView!
    
    func setup(tvShow: TVShow) {
       
        posterShadowView.applyShadow(cornerRadius: posterImageView.layer.cornerRadius)
        
        guard let imageUrl = tvShow.image?.medium else { return }
        
        posterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"), options: [], context: nil)
        
    }
    
}
