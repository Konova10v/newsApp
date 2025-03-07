//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import Foundation

final class NewsViewModel: ObservableObject {
	let networkManager = NetworkManager.shared
	@Published var newsData: NewsModel = .placeholder
	
	@Published var searchQuery: String = ""
	
	init() {
		getNews()
	}

	// Получение всех новостей
	func getNews() {
		networkManager.getNews { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let news):
					self.newsData = news
				case .failure(let error):
					print("Ошибка загрузки новостей: \(error.localizedDescription)")
				}
			}
		}
	}
	
	// Метод для поиска новости но заголовку и аннотации
	var filteredNews: [News] {
		if searchQuery.isEmpty {
			return newsData.data?.news ?? []
		} else {
			let news: [News] = newsData.data?.news ?? []
			return news.filter {
				($0.title?.localizedCaseInsensitiveContains(searchQuery) == true) ||
				($0.annotation?.localizedCaseInsensitiveContains(searchQuery) == true)
			}
		}
	}
}

