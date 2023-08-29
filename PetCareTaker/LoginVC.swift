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
        
        let allCheckText = AuthenticationManager.shared.checkAndResult(account: accountCheckResult, password: passwordCheckResult)
        
        checkPhoneLogin.text = allCheckText.accountResult
        checkPasswordLogin.text = allCheckText.passwordResult
        
        if allCheckText.accountResult == "格式有效" {
            DispatchQueue.main.async {
                AuthenticationManager.shared.accountLoginSuccessUpdateUI(accountLabel: self.checkPhoneLogin, accountImage: self.checkPhoneLoginImage)
            }
        } else {
            print("\(allCheckText.accountResult)")
            DispatchQueue.main.async {
                AuthenticationManager.shared.accountLoginErrorUpdateUI(accountTextField: self.userPhoneLogin, accountLabel: self.checkPhoneLogin, accountImage: self.checkPhoneLoginImage)
            }
        }
        
        if allCheckText.passwordResult == "格式有效" {
            DispatchQueue.main.async {
                AuthenticationManager.shared.passwordLoginSuccessUpdateUI(passwordLabel: self.checkPasswordLogin, passwordImage: self.checkPasswordLoginImage)
                
            }
        } else {
            DispatchQueue.main.async {
                AuthenticationManager.shared.passwordLoginErrorUpdateUI(passwordTextField: self.userPasswordLogin, passwordLabel: self.checkPasswordLogin, passwordImage: self.checkPasswordLoginImage)
            }
        }
        if accountCheckResult == .valid && passwordCheckResult == .valid {
            
            let passwordHash = AuthenticationManager.shared.sha256(password) // 將密碼進行SHA-256加密
                    
            let url = URL(string: ServerApiHelper.shared.loginUserUrl)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let params = "Phone=\(phone)&Password=\(passwordHash)"
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
                            let alert = UIAlertController(title: "登入失敗", message: "帳號或密碼錯誤", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "帳號或密碼錯誤", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    @IBAction func goRegister(_ sender: Any) {
        performSegue(withIdentifier: "goRegister", sender: nil)
    }
}


