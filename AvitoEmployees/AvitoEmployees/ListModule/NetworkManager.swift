//
//  NetworkManager.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import Foundation

protocol INetworkManager {
    func loadData<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void)
    func getUrl() -> String
}

final class NetworkManager {
    
    private enum Literal {
        static let url = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    }
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
//
//    init(configuration: URLSessionConfiguration? = nil) {
//        if let configuration = configuration {
//            self.session = URLSession(configuration: configuration)
//        }
//        else {
//            self.session = URLSession(configuration: URLSessionConfiguration.default)
//        }
//    }
}

//MARK: INetworkManager
extension NetworkManager: INetworkManager {
    
    func loadData<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getUrl() -> String {
        return Literal.url
    }
}
    
