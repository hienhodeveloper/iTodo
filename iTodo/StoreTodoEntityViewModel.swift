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
    
    func loadTodo() {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        do {
            todoList.removeAll()
            todoList = try context.fetch(request).reversed()
            print("Load success")
        } catch {
            print("Load error: \(error)")
        }
    }
    
    func insertTodo() {
        let todo = TodoEntity(context: context)
        todo.title = title
        todo.done = false
        todoList.insert(todo, at: 0)
        saveTodo()
    }
    
    func removeTodo(at index: IndexPath) {
        context.delete(todoList[index.row])
        saveTodo()
        todoList.remove(at: index.row)
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
            todoList = try context.fetch(request)
            completion()
        } catch {
            print("Search - error: \(error)")
        }
    }
}

