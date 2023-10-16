//
//  TextViewExtensionn.swift
//  iOS App
//
//  Created by TC Lee on 2023/9/7.
//

import Foundation
import UIKit
extension UITextView {
    
    /*
     Add a signle line as bottom border beneath the TextView.
     */
    func addBottomBorder(borderColor:CGColor, borderWidth: CGFloat){
        
        let imageView = UIImageView()
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor
        imageView.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 0.5)
        self.addSubview(imageView)

    }
    
    
    /*
     Add a char calculater, dynamically calculate user's current input and feedback to user.
     */
    
    func addCharCalculator(max:Int){
        let textLabel = UILabel()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var currentCharNum = String(formatter.string(from: NSNumber(value: self.text.count ))!)
        let maxNum = String(formatter.string(from: NSNumber(value: max))!)
        textLabel.text = "\(currentCharNum)/\(maxNum)"
        textLabel.textColor = .tertiaryLabel
        textLabel.font = .systemFont(ofSize: 13)
        textLabel.frame = CGRect(x: self.width - textLabel.intrinsicContentSize.width,
                                 y: self.height - textLabel.intrinsicContentSize.height,
                                 width: textLabel.intrinsicContentSize.width,
                                 height: textLabel.intrinsicContentSize.height)
        self.addSubview(textLabel)
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: nil) { [weak self] _ in
                    guard let self = self else { return }
                    
                    // Update the character count dynamically
                    currentCharNum = String(formatter.string(from: NSNumber(value: self.text.count ))!)
                    textLabel.text = "\(currentCharNum)/\(maxNum)"
                    
                    // Adjust the label's frame if needed
                    textLabel.frame.size = textLabel.intrinsicContentSize
                    textLabel.frame.origin.x = self.width - textLabel.intrinsicContentSize.width - 5
                    textLabel.frame.origin.y = self.height - textLabel.intrinsicContentSize.height
                }
    }
    
    
    
    

    
}
