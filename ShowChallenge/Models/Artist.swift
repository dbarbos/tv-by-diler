//
//  Artist.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation

struct ArtistQueryResult: Decodable {
    let score: Double
    let person: ArtistDetail
}

struct ArtistDetail: Decodable {
    let id: Int
    let name: String
    let country: ArtistCountry?
    let gender: String?
    let image: ArtistImageURL?
}

struct ArtistCountry: Decodable {
    let name: String?
    let code: String?
}

struct ArtistImageURL: Decodable {
    let medium: String?
    let original: String?
}
