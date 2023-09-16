//
//  TextViewCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/12.
//

import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {
    
    var textViewHeightConstraint: NSLayoutConstraint?
    
    let textView: WSPlaceholderTextView = {
        let textView = WSPlaceholderTextView()
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false // 關閉滾動
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 添加 UIButtonMenu 作為子視圖
        contentView.addSubview(textView)
        
        textView.delegate = self
        
        // 設置 UIButtonMenu 的約束，根據您的界面設計來調整
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            // 示例約束：將 buttonMenu 放在單元格的左側並置中
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        // 添加底部邊框
        textView.addBottomBorder(borderColor: UIColor.lightGray.cgColor, borderWidth: 40)
        
        // 添加字符計數器
        textView.addCharCalculator(max: 500) // 字符上限
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}


