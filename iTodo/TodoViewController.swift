//
//  ViewController.swift
//  iTodo
//
//  Created by Hien Ho on 1/14/20.
//  Copyright © 2020 TeamLuna. All rights reserved.tableView.cellForRow(at: indexPath)?.accessoryType
//

import UIKit
import SnapKit

class TodoViewController: UIViewController {
    lazy var container = UIView()
    lazy var todoTableView = UITableView()
    var searchController = UISearchController(searchResultsController: nil)
    var selectCategory: CategoryEntity?
    
    private let todoCellID = "categoryCellID"
    
    var storeViewModel: StoreTodoEntityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigation()
        setupContraints()
        setupData()
        setupTodoTableView()
    }
    
    func setupData() {
        
        storeViewModel.loadTodo()
    }
    
    func setupNavigation() {
        // add bar button
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(TodoViewController.addTodo(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton
        
        // title
        title = storeViewModel.category?.name ?? "TODO"
        
        // large title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    // MARK: Actions
    @objc func addTodo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a todo", message: "", preferredStyle: .alert)
        var todoTextField: UITextField!
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard let self = self, let todo = todoTextField.text else { return }
            guard todo.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
            // insert first
            self.storeViewModel.title = todo
            self.storeViewModel.insertTodo()
            self.todoTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
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
}
// MARK: Setup UI
extension TodoViewController {
    func setupContraints() {
        // add subviews
        view.addSubview(container)
        container.addSubview(todoTableView)
        
        // setup contraint
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        todoTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

// MARK: Setup tableView
extension TodoViewController {
    func setupTodoTableView() {
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.rowHeight = UITableView.automaticDimension
        todoTableView.estimatedRowHeight = 44
        todoTableView.register(TodoTableCell.self, forCellReuseIdentifier: todoCellID)
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeViewModel.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoCellID, for: indexPath) as! TodoTableCell
        cell.todo = storeViewModel.todoList[indexPath.row]
        print("cell init \(indexPath.row)")
        return cell
    }
}

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        storeViewModel.todoList[indexPath.row].setValue(!storeViewModel.todoList[indexPath.row].done, forKey: "done")
        storeViewModel.saveTodo()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self](action, sourceView, completionHandler) in
            self?.storeViewModel.removeTodo(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
            completionHandler(true)
        }
        let rename = UIContextualAction(style: .normal, title: "Edit") { [weak self](action, sourceView, completionHandler) in
            self?.updateTodo(index: indexPath)
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
        //let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func updateTodo(index: IndexPath) {
        let todo = storeViewModel.todoList[index.row]
        let alert = UIAlertController(title: "Edit todo", message: "", preferredStyle: .alert)
        var todoTextField: UITextField!
        
        let action = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let self = self, let td = todoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            guard td.count > 0, todo.title != td else { return }
            // insert first
            todo.title = td
            self.storeViewModel.saveTodo()
            self.todoTableView.reloadRows(at: [index], with: .fade)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alert.addTextField {
            alertTextField in
            todoTextField = alertTextField
            todoTextField.text = todo.title
            todoTextField.placeholder = "todo title"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension TodoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = (searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
        storeViewModel.search(for: text) {
            self.todoTableView.reloadData()
        }
    }
}
