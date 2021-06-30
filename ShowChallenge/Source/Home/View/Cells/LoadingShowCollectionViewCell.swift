//
//  IndicatorCollectionViewCell.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import UIKit

class LoadingShowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    func setup() {
        activitiIndicator.startAnimating()
    }
}
