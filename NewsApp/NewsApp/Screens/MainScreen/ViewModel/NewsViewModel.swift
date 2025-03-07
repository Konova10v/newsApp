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

	func getNews() {
		networkManager.getNews { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let news):
					print("test111 \(news)")
					self.newsData = news
				case .failure(let error):
					print("Ошибка загрузки новостей: \(error.localizedDescription)")
				}
			}
		}
	}
}

