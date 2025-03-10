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
					let hiddenIDs = self.coreDataManager.getHiddenNewsIDs() // Список скрытых ID
					let filteredNews = news.data?.news?.filter { !hiddenIDs.contains($0.id ?? 0) } ?? [] // Фильтр скрытых новостей

					self.coreDataManager.deleteAllNews()
					self.coreDataManager.saveNews(filteredNews, context: self.coreDataManager.context)

					self.loadNews()
				case .failure(let error):
					print("Ошибка загрузки новостей: \(error.localizedDescription)")
				}
			}
		}
	}

	// Скрытие новости
	func hideNews(id: Int) {
		coreDataManager.hideNews(id: id)
		loadNews()
	}

	// Метод для поиска новости но заголовку и аннотации
	var filteredNews: [News] {
		let news = newsData.data?.news ?? []
		if searchQuery.isEmpty {
			return news
		} else {
			return news.filter {
				($0.title?.localizedCaseInsensitiveContains(searchQuery) == true) ||
				($0.annotation?.localizedCaseInsensitiveContains(searchQuery) == true)
			}
		}
	}
}
