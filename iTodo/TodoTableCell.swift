//
//  TodoTableCell.swift
//  iTodo
//
//  Created by Hien Ho on 1/17/20.
//  Copyright © 2020 TeamLuna. All rights reserved.
//

import UIKit

class TodoTableCell: UITableViewCell {
    lazy var containerView = UIView()
    lazy var todoTitle = Init(value: UILabel()) {
        $0.text = ""
        $0.textColor = .darkGray
        $0.numberOfLines = 0
        $0.font.withSize(16)
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    var todo: TodoEntity! {
        didSet {
            todoTitle.text = todo.title ?? ""
            if todo.done {
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if todo.done {
            todoTitle.textColor = .systemGreen
            accessoryType = .checkmark
        } else {
            todoTitle.textColor = .darkGray
            accessoryType = .none
        }
    }

    func setupUI() {
        addSubview(containerView)
        containerView.addSubview(todoTitle)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        todoTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8).priority(.low)
        }
    }
    
}

