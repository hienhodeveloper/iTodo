//
//  CategoryTableCell.swift
//  iTodo
//
//  Created by Hien Ho on 1/14/20.
//  Copyright © 2020 TeamLuna. All rights reserved.
//

import UIKit
import SnapKit

class CategoryTableCell: UITableViewCell {
    lazy var containerView = UIView()
    lazy var categoryTitle = Init(value: UILabel()) {
        $0.text = ""
        $0.textColor = .darkGray
        $0.numberOfLines = 0
        $0.font.withSize(16)
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    var title: String? {
        didSet {
            categoryTitle.text = title ?? "no task"
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
        if self.accessoryType == .checkmark {
            categoryTitle.textColor = .systemGreen
        } else {
            categoryTitle.textColor = .darkGray
        }
    }

    func setupUI() {
        addSubview(containerView)
        containerView.addSubview(categoryTitle)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
}
