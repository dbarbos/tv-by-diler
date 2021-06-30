//
//  ArtistTableViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var pictureShadowView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func setup(artist: ArtistDetail) {
        
        nameLabel.text = artist.name
        
        pictureShadowView.applyShadow(cornerRadius: pictureImageView.layer.cornerRadius)
        
        guard let imageUrl = artist.image?.medium else { return }
        
        pictureImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
    }
    
}
