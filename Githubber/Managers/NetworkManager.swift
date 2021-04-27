//
//  NetworkManager.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/27.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    
    private init () {
        
    }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> (Void)) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        print("endpoint is \(endpoint)")
        //URL Error handling
        guard let url = URL(string: endpoint) else {
            print("error 1")
            completion(.failure(.invalidUserName))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("error 2, \(err)")
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("error 3")
                completion(.failure(.invalidResponse))
                return
            }
            print(response.statusCode)
            guard let data = data else {
                print("error 4")
                completion(.failure(.invalidResponse))
                return
            }
            print(data)
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                print("success getting followers")
                completion(.success(followers))
            } catch let decodingError {
                print("error 5")
                print(decodingError)
                completion(.failure(.failedToDecode))
            }
            
        }
        
        task.resume()
    }
}
