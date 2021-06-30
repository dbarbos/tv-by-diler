//
//  UIImageView+Extensions.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 16
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        let layerName = "gradientLayer"
        self.layer.sublayers?.forEach({ (layer) in
            if layer.name == layerName {
                layer.removeFromSuperlayer()
            }
        })
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.locations = [0.0, 0.8]
        gradient.colors = colors.map{$0.cgColor}
        gradient.name = "gradientLayer"
        self.layer.addSublayer(gradient)
    }
}
