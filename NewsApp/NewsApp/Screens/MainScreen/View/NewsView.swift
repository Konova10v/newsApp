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
					List(viewModel.filteredNews) { new in
						Button {
							if let siteURL = new.mobileURL, let url = URL(string: siteURL) {
								selectedNewsURL = url
							}
						} label: {
							VStack(spacing: 20) {
								if let flagURL = new.img, let url = URL(string: flagURL) {
									AsyncImage(url: url) { image in
										image
											.resizable()
											.scaledToFill()
											.frame(height: 150)
											.cornerRadius(5)
									} placeholder: {
										Rectangle()
											.fill(Color.gray.opacity(0.3))
											.frame(height: 150)
											.cornerRadius(5)
									}
								}
								
								VStack(alignment: .leading, spacing: 10) {
									Text(new.title ?? "")
										.bold()
									
									Text(new.annotation ?? "")
									
									Text(new.newsDate ?? "")
										.font(.system(size: 11))
								}
							}
						}
					}
				}
			}
			.searchable(text: $viewModel.searchQuery)
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
