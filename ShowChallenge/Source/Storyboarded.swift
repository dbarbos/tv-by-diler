//
//  Storyboarded.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation
import UIKit

// MARK: - Protocol
protocol Storyboarded {
    static func instantiate() -> Self
}

// MARK: - Extensions
extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: id, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}
