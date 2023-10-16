//
//  ButtonMenuCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/12.
//

import UIKit

class ButtonMenuCell: UITableViewCell {
    
    let buttonMenu: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.setTitleColor(.label, for: .normal)
        button.menu = UIMenu(children: [
            UIAction(title: "選項1", handler: { action in
            print("選項1")})
        ])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constraints.cornerRadious
        button.backgroundColor = .secondarySystemBackground
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        button.layer.shadowOpacity = 0.5 // 陰影不透明度
        button.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        button.layer.shadowRadius = 5 // 陰影半徑
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 添加 UIButtonMenu 作為子視圖
        contentView.addSubview(buttonMenu)
        
        // 設置 UIButtonMenu 的約束，根據您的界面設計來調整
        buttonMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonMenu.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            buttonMenu.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            buttonMenu.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            buttonMenu.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

