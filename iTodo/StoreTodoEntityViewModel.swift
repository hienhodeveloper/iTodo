//
//  StoreTodoEntityViewModel.swift
//  iTodo
//
//  Created by Hien Ho on 1/15/20.
//  Copyright © 2020 TeamLuna. All rights reserved.
//
import UIKit
import CoreData

class StoreTodoEntityViewModel {
    var categoryList: [TodoEntity]!
    let context: NSManagedObjectContext!
    
    var title: String = ""
    
    init() {
        categoryList = []
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func saveTodo() {
        do {
            try context.save()
            print("Save TodoEntity success")
        } catch {
            print("Save TodoEntity error: \(error)")
        }
    }
    
    func loadTodo() {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        do {
            categoryList.removeAll()
            categoryList = try context.fetch(request).reversed()
            print("Load success")
        } catch {
            print("Load error: \(error)")
        }
    }
    
    func insertTodo() {
        let todo = TodoEntity(context: context)
        todo.title = title
        todo.done = false
        categoryList.insert(todo, at: 0)
        saveTodo()
    }
    
    func removeTodo(at index: IndexPath) {
        context.delete(categoryList[index.row])
        saveTodo()
        categoryList.remove(at: index.row)
    }
    
    func search(for text: String, completion: () -> Void) {
        if text.count == 0 {
            loadTodo()
            completion()
            return
        }
        
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        do {
            categoryList = try context.fetch(request)
            completion()
        } catch {
            print("Search - error: \(error)")
        }
    }
}
