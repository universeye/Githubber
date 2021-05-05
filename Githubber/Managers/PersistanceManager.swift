//
//  PersistanceManager.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/5/3.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}


enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorites: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            
            case .success(var favorite):
                
                
                switch actionType {
                case .add:
                    //check if you already add the user
                    guard !favorite.contains(favorites) else {
                        completion(.alreadyInFav)
                        return
                    }
                    //if not, add the user you've passed in to the retrievedFavorites array
                    favorite.append(favorites)
                    
                    
                case .remove:
                    favorite.removeAll {
                        $0.login == favorites.login
                    }
                }
                
                //save the array to user defaults
                completion(saveToFavorites(favorites: favorite))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritsData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritsData)
            completed(.success(favorites))
        } catch let decodingError {
            print("error 6")
            print(decodingError)
            completed(.failure(.unableToFavorites))
        }
    }
    
    static func saveToFavorites(favorites: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorites
        }
    }
}
