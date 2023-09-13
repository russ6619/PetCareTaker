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
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 添加 UIButtonMenu 作為子視圖
        contentView.addSubview(buttonMenu)
        
        // 設置 UIButtonMenu 的約束，根據您的界面設計來調整
        buttonMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonMenu.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonMenu.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonMenu.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonMenu.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

