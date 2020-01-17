//
//  StoreCategoryViewModel.swift
//  iTodo
//
//  Created by Hien Ho on 1/17/20.
//  Copyright © 2020 TeamLuna. All rights reserved.
//

import UIKit
import CoreData

class StoreCategoryEntityViewModel {
    var categoryList: [CategoryEntity]!
    let context: NSManagedObjectContext!
    
    var title: String = ""
    
    init() {
        categoryList = []
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func saveCategory() {
        do {
            try context.save()
            print("Save CategoryEntity success")
        } catch {
            print("Save CategoryEntity error: \(error)")
        }
    }
    
    func loadCategory(with request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest() ) {
        do {
            categoryList.removeAll()
            categoryList = try context.fetch(request).reversed()
            print("Load success")
        } catch {
            print("Load error: \(error)")
        }
    }
    
    func insertTodo() {
        let category = CategoryEntity(context: context)
        category.name = title
        categoryList.insert(category, at: 0)
        saveCategory()
    }
    
    func removeTodo(at index: IndexPath) {
        context.delete(categoryList[index.row])
        saveCategory()
        categoryList.remove(at: index.row)
    }
    
    func search(for text: String, completion: () -> Void) {
        if text.count == 0 {
            loadCategory()
            completion()
            return
        }
        
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        do {
            categoryList = try context.fetch(request)
            completion()
        } catch {
            print("Search - error: \(error)")
        }
    }
}


