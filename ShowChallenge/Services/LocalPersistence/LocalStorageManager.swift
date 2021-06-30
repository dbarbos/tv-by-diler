//
//  LocalStorageManager.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import Foundation
import UIKit

// MARK: Protocol
protocol LocalStorageManagerProtocol {
    func getFavorites() -> [Favorite]
    func isFavorite(_ showId: Int) -> Bool
    func toggleFavorite(_ show: TVShow) -> Bool
    func addToFavorite(show: TVShow)
    func removeFromFavorite(_ showID: Int)
    func removeFromFavorite(_ favorite: Favorite)
}

// MARK: LocalStorageManager
class LocalStorageManager: LocalStorageManagerProtocol {
    
    static let shared = LocalStorageManager()
    
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getFavorites() -> [Favorite] {
        do {
            let favorites = try context.fetch(Favorite.fetchRequest()).map({ $0 as! Favorite})
            return favorites
        } catch (let error) {
            print(error)
        }
        
        return []
    }
    
    func isFavorite(_ showId: Int) -> Bool {
        
        let favorites = getFavorites()
        return favorites.contains(where: { $0.id == showId })
        
    }
    
    func toggleFavorite(_ show: TVShow) -> Bool {
        
        guard let favorite = getFavorites().first(where: { $0.id == show.id }) else {
            addToFavorite(show: show)
            return true
        }
        
        removeFromFavorite(favorite)
        
        return false
        
    }
    
    func addToFavorite(show: TVShow) {
        let newItem = Favorite(context: context)
        newItem.id = Int64(show.id)
        newItem.name = show.name
        newItem.posterUrl = show.image?.medium
        newItem.summary = show.summary
        
        do {
            try context.save()
        } catch {
            print("Oops! Something went wrong :(")
        }
    }
    
    func removeFromFavorite(_ showID: Int) {
        guard let favorite = getFavorites().first(where: { $0.id == showID }) else { return }
        removeFromFavorite(favorite)
    }
    
    func removeFromFavorite(_ favorite: Favorite) {
        context.delete(favorite)
        
        do {
            try context.save()
        } catch {
            print("Oops! Something went wrong :(")
        }
        
    }
    
}
