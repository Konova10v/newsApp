//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import Foundation

class NetworkManager {
	static let shared = NetworkManager()
	private let baseURL = "http://dev.docker.otr-soft.ru:947/api/mobile/news/list"
	
	func getNews(completion: @escaping (Result<NewsModel, Error>) -> Void) {
		guard let url = URL(string: baseURL) else {
			completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let newsResponse = try decoder.decode(NewsModel.self, from: data)
				completion(.success(newsResponse))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}
