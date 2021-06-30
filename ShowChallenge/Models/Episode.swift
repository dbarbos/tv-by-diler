//
//  Episode.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String?
    let season: Int
    let number: Int
    let airdate: String?
    let airtime: String?
    let runtime: Int?
    let image: TVShowImagesURL?
    let summary: String?
}
