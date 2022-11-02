//
//  Networking.swift
//  AvitoTraineeProblem
//
//  Created by Fed on 31.10.2022.
//

import Foundation

final class NetworkService {
    
    // MARK: - Local Constants
    
    private let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    private let cacheExparationTime: Double = 3600
    private let decoder = JSONDecoder()
    
    private lazy var urlCache: URLCache = {
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: "JsonCacheFolder")
        return cache
    }()
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    // MARK: - Public Methods
    
    func fetchData(completion: @escaping (Result<Corporations, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        if let cachedData = loadFromCache(with: url) {
            completion(.success(cachedData))
            return
        }
        
        performRequest(with: url, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func performRequest(with url: URL, completion: @escaping(Result<Corporations, NetworkError>) -> Void) {
        urlSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(NetworkError.requestError(error?.localizedDescription)))
                return
            }
            guard let data = data, let response = response else {
                completion(.failure(NetworkError.sessionError(error?.localizedDescription)))
                return
            }
            
            self.saveToCache(with: data, and: response)
            
            guard let decodedData = try? self.decoder.decode(Corporations.self, from: data) else {
                completion(.failure(NetworkError.decodingError(error?.localizedDescription)))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(decodedData))
            }
            
        }.resume()
    }
    
    private func saveToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedResponse, for: request)
        DispatchQueue(label: "ru.teodor.AvitoTraineeProblem - NetworkService", qos: .background).asyncAfter(deadline: .now() + cacheExparationTime) {
            self.urlCache.removeAllCachedResponses()
        }
    }
    
    private func loadFromCache(with url: URL) -> Corporations? {
        let request = URLRequest(url: url)
        guard let cachedResponse = urlCache.cachedResponse(for: request)
        else {
            return nil
        }
        
        guard let decodedData = try? decoder.decode(Corporations.self, from: cachedResponse.data) else {
            return nil
        }
        return decodedData
    }
}
