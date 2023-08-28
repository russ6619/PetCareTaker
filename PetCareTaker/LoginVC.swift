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
    
    @IBOutlet weak var checkPhoneLogin: UILabel!
    @IBOutlet weak var checkPasswordLogin: UILabel!
    
    @IBOutlet weak var checkPhoneLoginImage: UIImageView!
    @IBOutlet weak var checkPasswordLoginImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func loginCheck(_ sender: Any) {
        
        guard let phone = userPhoneLogin.text,
              let password = userPasswordLogin.text else {
            return
        }
        let accountCheckResult = AuthenticationManager.shared.checkAccountCorrection(phone)
        let passwordCheckResult = AuthenticationManager.shared.checkPassword(password)
        
        if accountCheckResult != .valid {
            // 處理帳號檢查結果，類似之前的邏輯
            // ...
            return
        }
        
        if passwordCheckResult != .valid {
            // 處理密碼檢查結果，類似之前的邏輯
            // ...
            return
        }
        
        let url = URL(string: ServerApiHelper.shared.loginUserUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = "Phone=\(phone)&Password=\(password)"
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let data = data,
               let result = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if result == "true" {
                        // 密碼驗證成功，執行登入後的相關操作
                        // 例如切換到下一個畫面
                        self.performSegue(withIdentifier: "loginSuccessSegue", sender: nil)
                    } else {
                        // 密碼驗證失敗，顯示錯誤提示
                        self.checkPasswordLogin.text = "帳號或密碼錯誤"
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    @IBAction func goRegister(_ sender: Any) {
        performSegue(withIdentifier: "goRegister", sender: nil)
    }
}


