//
//  URL.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

import Foundation

extension URL: @retroactive Identifiable {
	public var id: String { absoluteString }
}
