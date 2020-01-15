//
//  StoreTodoViewModel.swift
//  iTodo
//
//  Created by Hien Ho on 1/15/20.
//  Copyright © 2020 TeamLuna. All rights reserved.
//

import Foundation

class StoreTodoViewModel {
    private let categoryListKey = "categoryList.plist"

    var categoryList: [Todo] = []
    let store = UserDefaults.standard
    var dataFilePath: URL!
    
    init() {
        dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(categoryListKey)
    }
    
    func saveTodo() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(categoryList)
            try data.write(to: dataFilePath!)
            print("saved")
        } catch {
             print("error: \(error)")
        }
    }
    
    func loadTodo() {
        guard let data = try? Data(contentsOf: dataFilePath) else { return }
        let decoder = PropertyListDecoder()
        do {
            categoryList = try decoder.decode([Todo].self, from: data)
        } catch {
            print("error decode to get data\(error)")
        }
    }
}
