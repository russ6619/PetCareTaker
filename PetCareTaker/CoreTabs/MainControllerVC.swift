//
//  ControllerVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/29.
//

import UIKit

class MainControllerVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.selectedIndex = 1
        
        self.tabBarController?.tabBar.layer.borderWidth = 1
        self.tabBarController?.tabBar.layer.borderColor = UIColor.black.cgColor
    }
    
    

}
