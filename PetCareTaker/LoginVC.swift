//
//  ViewController.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit
import CryptoKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var userPhoneLogin: UITextField!
    @IBOutlet weak var userPasswordLogin: UITextField!
    
    @IBOutlet weak var didNotHaveAnAccountLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func loginCheck(_ sender: Any) {
    }
    @IBAction func goRegister(_ sender: Any) {
    }
}

