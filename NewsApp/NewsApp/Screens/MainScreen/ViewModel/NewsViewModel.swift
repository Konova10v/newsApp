//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import Foundation

final class NewsViewModel: ObservableObject {
	let networkManager = NetworkManager.shared
	let coreDataManager = CoreDataManager.shared
	
	@Published var newsData: NewsModel = .placeholder
	
	@Published var searchQuery: String = ""
	
	init() {
		loadNews()
	}
	
	func loadNews() {
		let savedNews = coreDataManager.fetchNews()
		
		if !savedNews.isEmpty {
			self.newsData = NewsModel(success: true, data: DataClass(news: savedNews, count: savedNews.count, errorMsg: nil))
		} else {
			getNews()
		}
	}

	// Получение всех новостей
	func getNews() {
		networkManager.getNews { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let news):
					self.newsData = news
					self.coreDataManager.deleteAllNews()
					self.coreDataManager.saveNews(news.data?.news ?? [], context: CoreDataManager.shared.context)
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
	
	// Очистка базы с новостями
	func deleteNews() {
		coreDataManager.deleteAllNews()
	}
}
