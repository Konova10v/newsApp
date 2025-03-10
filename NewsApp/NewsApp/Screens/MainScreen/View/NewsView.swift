//
//  NewsView.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import SwiftUI

struct NewsView: View {
	@ObservedObject var viewModel: NewsViewModel = NewsViewModel()
	@State private var selectedNewsURL: URL?
	
    var body: some View {
		NavigationView {
			VStack {
				if viewModel.filteredNews.isEmpty {
					Spacer()
					
					ProgressView()
					
					Spacer()
				} else {
					List(viewModel.filteredNews) { news in
						Button {
							if let siteURL = news.mobileURL, let url = URL(string: siteURL) {
								selectedNewsURL = url
							}
						} label: {
							VStack(spacing: 20) {
								if let imageURL = news.img, let url = URL(string: imageURL) {
									CachedAsyncImage(url: url)
								}
								
								VStack(alignment: .leading, spacing: 10) {
									Text(news.title ?? "")
										.bold()
									
									Text(news.annotation ?? "")
									
									Text(news.newsDate ?? "")
										.font(.system(size: 11))
								}
							}
						}
						.swipeActions(edge: .trailing) {
							Button(role: .destructive) {
								viewModel.hideNews(id: news.id ?? 0)
							} label: {
								Label("Скрыть", systemImage: "eye.slash")
							}
						}
					}
				}
			}
			.searchable(text: $viewModel.searchQuery, prompt: "Поиск новости")
			.navigationTitle("Новости")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button(action: {
						viewModel.newsData = .placeholder
						viewModel.getNews()
					} ) {
						Image(systemName: "goforward")
					}
				}
			}
			.sheet(item: $selectedNewsURL) { url in
				SafariView(url: url)
			}
		}
    }
}

#Preview {
    NewsView()
}
