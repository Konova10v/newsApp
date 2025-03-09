//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by Кирилл Коновалов on 08.03.2025.
//

import CoreData

final class CoreDataManager {
	static let shared = CoreDataManager()
	
	let persistentContainer: NSPersistentContainer
	
	var context: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	private init() {
		persistentContainer = NSPersistentContainer(name: "NewsEntity")
		persistentContainer.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Ошибка инициализации: \(error.localizedDescription)")
			}
		}
	}
	
	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Ошибка сохранения: \(error.localizedDescription)")
			}
		}
	}
}

extension CoreDataManager {
	func saveNews(_ newsArray: [News], context: NSManagedObjectContext) {
		for news in newsArray {
			let newEntity = NewsEntity(context: context)
			
			newEntity.id = Int64(news.id ?? 0)
			newEntity.title = news.title
			newEntity.img = news.img
			newEntity.localImg = news.localImg
			newEntity.newsDate = news.newsDate
			newEntity.annotation = news.annotation
			newEntity.idResource = Int64(news.idResource ?? 0)
			newEntity.type = Int64(news.type ?? 0)
			newEntity.newsDateUts = 0
			newEntity.mobileURL = news.mobileURL
		}
		
		do {
			try context.save()
		} catch {
			print("Ошибка сохранения новостей: \(error.localizedDescription)")
		}
	}
	
	func fetchNews() -> [News] {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
		
		do {
			let entities = try context.fetch(fetchRequest)
			return entities.map { entity in
				News(
					id: Int(entity.id),
					title: entity.title,
					img: entity.img,
					localImg: entity.localImg,
					newsDate: entity.newsDate,
					annotation: entity.annotation,
					idResource: Int(entity.idResource),
					type: Int(entity.type),
					newsDateUts: String(entity.newsDateUts),
					mobileURL: entity.mobileURL
				)
			}
		} catch {
			print("Ошибка загрузки новостей из CoreData: \(error.localizedDescription)")
			return []
		}
	}
	
	func deleteAllNews() {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NewsEntity.fetchRequest()
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			try context.execute(deleteRequest)
			saveContext()
		} catch {
			print("Ошибка удаления новостей: \(error.localizedDescription)")
		}
	}
}
