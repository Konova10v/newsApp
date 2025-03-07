//
//  NewsView.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import SwiftUI

struct NewsView: View {
	@ObservedObject var viewModel: NewsViewModel = NewsViewModel()
	
    var body: some View {
        Text("Hello, World!")
			.onAppear {
				viewModel.getNews()
			}
    }
}

#Preview {
    NewsView()
}
