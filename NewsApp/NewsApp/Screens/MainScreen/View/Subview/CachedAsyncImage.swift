//
//  CachedAsyncImage.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 10.03.2025.
//

import SwiftUI

class ImageCache {
	static let shared = NSCache<NSURL, UIImage>()
}

struct CachedAsyncImage: View {
	let url: URL?
	
	@State private var image: UIImage? = nil
	
	var body: some View {
		Group {
			if let image = image {
				Image(uiImage: image)
					.resizable()
					.scaledToFill()
					.frame(height: 150)
					.cornerRadius(5)
			} else {
				Rectangle()
					.fill(Color.gray.opacity(0.3))
					.frame(height: 150)
					.cornerRadius(5)
					.onAppear {
						loadImage()
					}
			}
		}
	}
	
	private func loadImage() {
		guard let url = url else { return }
		
		if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
			self.image = cachedImage
		} else {
			DispatchQueue.global().async {
				if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
					ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
					DispatchQueue.main.async {
						self.image = uiImage
					}
				}
			}
		}
	}
}
