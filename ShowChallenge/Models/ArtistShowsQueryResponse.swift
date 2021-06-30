//
//  ArtistShowsQueryResponse.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation


struct ArtistShowsQueryResponse: Decodable {
    let _embedded: ArtistEmbededShow?
}

struct ArtistEmbededShow: Decodable {
    let show: TVShow
}
