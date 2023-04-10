//
//  FavoritesManager.swift
//  Technical-test
//
//  Created by Pavlo Vasylenko on 10.04.2023.
//

import Foundation

//TODO: remove singletone, apply protocol based using of manager
public protocol FavoritesManagerProtocol {
    func isFavorite(_ key: String) -> Bool
    func setFavorite(_ isFavorite: Bool, for key: String)
    func toggleFavorite(key: String)
}

class FavoritesManager {

    //Yes, I know singletones are usually bad, but this service is called from 3 places and I am lack of time.
    static let shared = FavoritesManager()

    let kFavoritesKey = "kFavoritesKey";

    init() {
        if let favs = UserDefaults.standard.object(forKey: kFavoritesKey) as? [String] {
            favorites = favs
            print("favorites restored: \(favs)")
        }
    }

    //data keeper for FAV
    var favorites = [String]()

    public func isFavorite(_ key: String) -> Bool {
        let isFav = favorites.contains(key)
        return isFav
    }

    public func setFavorite(_ isFavorite: Bool, for key: String) {
        if isFavorite {
            favorites.append(key)
        } else {
            favorites.removeAll(where: { $0 == key })
        }

        //saving to UserDefaults for presistance
        UserDefaults.standard.set(favorites, forKey: kFavoritesKey)
        UserDefaults.standard.synchronize()
    }

    public func toggleFavorite(key: String) {
        let isFav = isFavorite(key)

        setFavorite(!isFav, for: key)
    }
}
