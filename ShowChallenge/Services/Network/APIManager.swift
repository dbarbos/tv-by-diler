//
//  ApiManager.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation
import Combine

// MARK: Protocol
protocol APIManagerProtocol {
    func getShows(from page: Int) -> AnyPublisher<[TVShow], Error>
    func getShows(using query: String) -> AnyPublisher<[TVShowQueryResult], Error>
    func getShows(for artistId: Int) -> AnyPublisher<[ArtistShowsQueryResponse], Error>
    func getShow(by id: Int) -> AnyPublisher<TVShow, Error>
    func getArtists(using query: String) -> AnyPublisher<[ArtistQueryResult], Error>
    func getEpisodes(showId: Int) -> AnyPublisher<[Episode], Error>
}

// MARK: APIManager
class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    
    private init() {}
    
    private let baseUrl = "http://api.tvmaze.com"
    
    func getShows(from page: Int) -> AnyPublisher<[TVShow], Error> {
        
        var urlComponent = URLComponents(string: baseUrl + path(for: .shows))!
        
        urlComponent.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        return URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .map{ $0.data }
            .decode(
                type: [TVShow].self,
                decoder: JSONDecoder()
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    func getShows(using query: String) -> AnyPublisher<[TVShowQueryResult], Error> {
        
        var urlComponent = URLComponents(string: baseUrl + path(for: .search))!
        
        urlComponent.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        return URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .map{ $0.data }
            .decode(
                type: [TVShowQueryResult].self,
                decoder: JSONDecoder()
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    func getShows(for artistId: Int) -> AnyPublisher<[ArtistShowsQueryResponse], Error> {
        
        var urlComponent = URLComponents(string: baseUrl + path(for: .showsForArtist(artistID: artistId)))!
        
        urlComponent.queryItems = [
            URLQueryItem(name: "embed", value: "show")
        ]
        
        return URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .map{ $0.data }
            .decode(
                type: [ArtistShowsQueryResponse].self,
                decoder: JSONDecoder()
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    func getShow(by id: Int) -> AnyPublisher<TVShow, Error> {
        
        let urlComponent = URLComponents(string: baseUrl + path(for: .showById(showId: id)))!
        
        return URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .map{ $0.data }
            .decode(
                type: TVShow.self,
                decoder: JSONDecoder()
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    func getArtists(using query: String) -> AnyPublisher<[ArtistQueryResult], Error> {
        
        var urlComponent = URLComponents(string: baseUrl + path(for: .searchPeople))!
        
        urlComponent.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        return URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .map{ $0.data }
            .decode(
                type: [ArtistQueryResult].self,
                decoder: JSONDecoder()
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    func getEpisodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        
        let urlComponent = URLComponents(string: baseUrl + path(for: .episode(showId: showId)))!
        
        return URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .map{ $0.data }
            .decode(
                type: [Episode].self,
                decoder: JSONDecoder()
            )
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

    }
    
    
}

// MARK: Extensions

extension APIManager {
    enum EndPoints {
        case shows, search, searchPeople, episode(showId: Int), showsForArtist(artistID: Int)
        case showById(showId: Int)
    }
    
    func path(for endpoint: EndPoints) -> String {
        switch endpoint {
        case .shows:
            return "/shows"
        case .search:
            return "/search/shows"
        case .searchPeople:
            return "/search/people"
        case .episode(let showId):
            return "/shows/\(showId)/episodes"
        case .showsForArtist(let artistID):
            return "/people/\(artistID)/castcredits"
        case .showById(let showId):
            return "/shows/\(showId)"
        }
    }
}
