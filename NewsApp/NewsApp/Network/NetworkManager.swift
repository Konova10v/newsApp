//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import Foundation

class NetworkManager {
	static let shared = NetworkManager()
	
	func getNews(completion: @escaping (Result<NewsModel, Error>) -> Void) {
		guard let url = URL(string: "http://dev.docker.otr-soft.ru:947/api/mobile/news/list") else {
			completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
				return
			}
			
			do {
				let countries = try JSONDecoder().decode(NewsModel.self, from: data)
				completion(.success(countries))
			} catch {
				completion(.failure(error))
			}
		}
			
		task.resume()
	}
}
