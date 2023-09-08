//
//  UIImage+Resize.swift
//  HelloMyChatroom
//
//  Created by 李暠勳 on 2023/8/1.
//

import UIKit

extension UIImage {
    func resize(maxEdge: CGFloat) -> UIImage? {
        
        // Check if it is necessary to resize?
        if self.size.width <= maxEdge && self.size.height <= maxEdge {
            return self
        }
        
        // Calculate final size with aspect ratio.
        let ratio = self.size.width / self.size.height
        let finalSize: CGSize
        if self.size.width > self.size.height {
            let finalHeight = maxEdge / ratio
            finalSize = CGSize(width: maxEdge, height: finalHeight)
        } else {    // height >= width
            let finalWidth = maxEdge * ratio
            finalSize = CGSize(width: finalWidth, height: maxEdge)
        }
        
        // Export as UIImage
        UIGraphicsBeginImageContext(finalSize)
        let rect = CGRect(origin: .zero, size: finalSize)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()   // Important 因為是oc的語法，一定要加END來釋放空間
        return result
    }
}
