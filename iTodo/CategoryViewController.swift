//
//  ViewController.swift
//  iTodo
//
//  Created by Hien Ho on 1/14/20.
//  Copyright © 2020 TeamLuna. All rights reserved.tableView.cellForRow(at: indexPath)?.accessoryType
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    lazy var container = UIView()
    lazy var categoryTableView = UITableView()
    
    private let categoryCellID = "categoryCellID"
    private let categoryListKey = "categoryListKey"

    var categoryList: [Todo] = []
    let store = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first?.appendingPathComponent("CategoryList")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigation()
        setupContraints()
        setupData()
        setupCategoryTableView()
    }
    
    func setupData() {
        guard let todo = store.array(forKey: categoryListKey) as? [Todo] else { return }
        categoryList += todo

    }
    
    func setupNavigation() {
        // add bar button
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(CategoryViewController.addTodo(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton
        
        // title
        title = "TODO"
        
        // large title
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Actions
    @objc func addTodo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a todo", message: "", preferredStyle: .alert)
        var todoTextField: UITextField!
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard let self = self, let todo = todoTextField.text else { return }
            guard todo.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
            // insert first
            self.categoryList.insert(Todo(title:todo), at: 0)
            self.categoryTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
            // save todo
            self.store.set(self.categoryList, forKey: self.categoryListKey)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alert.addTextField {
            alertTextField in
            todoTextField = alertTextField
            todoTextField.placeholder = "todo title"
            
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTodo() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(categoryList)
            try data.write(to: dataFilePath!)
        } catch {
            
        }
    }
}
// MARK: Setup UI
extension CategoryViewController {
    func setupContraints() {
        // add subviews
        view.addSubview(container)
        container.addSubview(categoryTableView)
        
        // setup contraint
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

// MARK: Setup tableView
extension CategoryViewController {
    func setupCategoryTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.rowHeight = UITableView.automaticDimension
        categoryTableView.estimatedRowHeight = 44
        categoryTableView.register(CategoryTableCell.self, forCellReuseIdentifier: categoryCellID)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryTableCell
        cell.todo = categoryList[indexPath.row]
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryList[indexPath.row].done = !categoryList[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
