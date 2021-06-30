//
//  TVShow.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation

struct TVShow: Decodable {
    let id: Int
    let url: String?
    let name: String
    let genres: [String]?
    let image: TVShowImagesURL?
    let schedule: TVShowSchedule?
    let summary: String?
    let premiered: String?
    let averageRuntime: Int?
    let rating: TVShowRating?
    let language: String?
    let status: String?
}

struct TVShowImagesURL: Decodable {
    let medium: String?
    let original: String?
}

struct TVShowSchedule: Decodable {
    let time: String?
    let days: [String]?
}

struct TVShowRating: Decodable {
    let average: Double?
}
