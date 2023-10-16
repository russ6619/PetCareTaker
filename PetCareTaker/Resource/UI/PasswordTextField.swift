//
//  PasswordTextField.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/24.
//

import UIKit

class PasswordTextField: UITextField {
    
    @objc func eyeButtonTap(button: UIButton) {
        if isFirstResponder {
            resignFirstResponder() // Hide the keyboard if it's currently shown
        }
        isSecureTextEntry = !isSecureTextEntry
        button.isSelected = !isSecureTextEntry
        becomeFirstResponder() // Restore the keyboard focus
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isSecureTextEntry = true
        rightViewMode = .always
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        button.isSelected = false
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        rightView = button
        button.addTarget(self, action: #selector(eyeButtonTap(button:)), for: .touchUpInside)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.width - 10 - 34, y: 0, width: 34, height: 34)
    }
}

extension UITextField {
    func setupTextFieldStyle() {
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1)
    }
}
