//
//  CustomTextField.swift
//  PiggyManageSystem
//
//  Created by 陳則丰 on 2023/10/1.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
        
    // Border style 不能選擇 Round
    // 設定高度 50, 重新調整 constraints
    private func configure() {
        // 移除原先的邊框樣式
        self.borderStyle = .none
        // 設定圓角參數
        self.layer.cornerRadius = 20
        // 設定邊框寬度
        self.layer.borderWidth = 0.7
        // 設定邊框顏色
        self.layer.borderColor = UIColor.gray.cgColor
        
        // 設定左側 padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        // 文字靠左
        self.textAlignment = .left
        // 設定文字顏色
        self.textColor = .darkGray
        // 設定文字大小
        self.font = UIFont.systemFont(ofSize: 18)
        // 設定背景顏色
        self.backgroundColor = .white
        
        // 顯示清除按鈕
        self.clearButtonMode = .whileEditing
    }
    
    // 設定預設文字及顏色
    func setPlaceholder(text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }

}
