//
//  Extension.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/1.
//

import Foundation
import UIKit


extension UIView {
    
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
    
    public var xCenter: CGFloat {
        return frame.origin.x + ( frame.size.width / 2)
    }
    
    public var yCenter: CGFloat {
        return frame.origin.y + ( frame.size.height / 2)
    }
}
