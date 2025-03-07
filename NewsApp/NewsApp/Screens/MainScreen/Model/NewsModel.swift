//
//  NewsModel.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 07.03.2025.
//

// MARK: - NewsModel
struct NewsModel: Codable {
	let success: Bool?
	let data: DataClass?
	
	public static var placeholder: Self {
		return NewsModel(success: nil, data: nil)
	}
}

// MARK: - DataClass
struct DataClass: Codable {
	let news: [News]?
	let count: Int?
	let errorMsg: String?

	enum CodingKeys: String, CodingKey {
		case news
		case count
		case errorMsg = "error_msg"
	}
}

// MARK: - News
struct News: Codable, Identifiable {
	let id: Int?
	let title: String?
	let img: String?
	let localImg: String?
	let newsDate: String?
	let annotation: String?
	let idResource: Int?
	let type: Int?
	let newsDateUts: String?
	let mobileURL: String?

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case img
		case localImg = "local_img"
		case newsDate = "news_date"
		case annotation
		case idResource = "id_resource"
		case type
		case newsDateUts = "news_date_uts"
		case mobileURL = "mobile_url"
	}
}
