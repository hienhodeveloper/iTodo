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
    var todoList: [TodoEntity]!
    let context: NSManagedObjectContext!
    
    var category: CategoryEntity?

    var title: String = ""
    
    init() {
        todoList = []
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
    
    func loadTodo(with request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest(), completion: (()->Void)? = nil) {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        let lastPredicaete = request.predicate
        let predicateList = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, lastPredicaete].compactMap{$0})
        request.predicate = predicateList
        do {
            todoList.removeAll()
            todoList = try context.fetch(request).reversed()
            print("Load success")
            completion?()
        } catch {
            print("Load error: \(error)")
        }
    }
    
    func insertTodo() {
        let todo = TodoEntity(context: context)
        todo.title = title
        todo.done = false
        todo.parentCategory = category
        todoList.insert(todo, at: 0)
        saveTodo()
    }
    
    func removeTodo(at index: IndexPath) {
        context.delete(todoList[index.row])
        saveTodo()
        todoList.remove(at: index.row)
    }
    
    func search(for text: String, completion: @escaping () -> Void) {
        if text.count == 0 {
            loadTodo()
            completion()
            return
        }
        
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        loadTodo(with: request) {
            completion()
        }
    }
}

