//
//  StartVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit
import CryptoKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var userAccountLogin: UITextField!
    @IBOutlet weak var userPasswordLogin: UITextField!
    
    @IBOutlet weak var didNotHaveAnAccountLabel: UILabel!
    
    @IBOutlet weak var checkAccountLogin: UILabel!
    @IBOutlet weak var checkPasswordLogin: UILabel!
    
    @IBOutlet weak var checkAccountLoginImage: UIImageView!
    @IBOutlet weak var checkPasswordLoginImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userAccountLogin.layer.masksToBounds = true
        userAccountLogin.layer.cornerRadius = 16
        userAccountLogin.returnKeyType = .continue
        userAccountLogin.leftViewMode = .always
        userAccountLogin.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        userAccountLogin.autocapitalizationType = .none
        userAccountLogin.autocorrectionType = .no
        
        userPasswordLogin.layer.masksToBounds = true
        userPasswordLogin.layer.cornerRadius = 16
        userPasswordLogin.returnKeyType = .continue
        userPasswordLogin.leftViewMode = .always
        userPasswordLogin.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        userPasswordLogin.autocapitalizationType = .none
        userPasswordLogin.autocorrectionType = .no
    }
    

    
    @IBAction func loginCheck(_ sender: Any) {
        
        guard let account = userAccountLogin.text,
              let password = userPasswordLogin.text else {
            return
        }
        let accountCheckResult = AuthManager.shared.checkAccountCorrection(account)
        let passwordCheckResult = AuthManager.shared.checkPassword(password)
        
        let allCheckText = AuthManager.shared.checkAndResult(account: accountCheckResult, password: passwordCheckResult)
        
        checkAccountLogin.text = allCheckText.accountResult
        checkPasswordLogin.text = allCheckText.passwordResult
        
        if allCheckText.accountResult == "格式有效" {
            DispatchQueue.main.async {
                AuthManager.shared.accountLoginSuccessUpdateUI(accountLabel: self.checkAccountLogin, accountImage: self.checkAccountLoginImage)
            }
        } else {
            print("\(allCheckText.accountResult)")
            DispatchQueue.main.async {
                AuthManager.shared.accountLoginErrorUpdateUI(accountTextField: self.userAccountLogin, accountLabel: self.checkAccountLogin, accountImage: self.checkAccountLoginImage)
            }
        }
        
        if allCheckText.passwordResult == "格式有效" {
            DispatchQueue.main.async {
                AuthManager.shared.passwordLoginSuccessUpdateUI(passwordLabel: self.checkPasswordLogin, passwordImage: self.checkPasswordLoginImage)
                
            }
        } else {
            DispatchQueue.main.async {
                AuthManager.shared.passwordLoginErrorUpdateUI(passwordTextField: self.userPasswordLogin, passwordLabel: self.checkPasswordLogin, passwordImage: self.checkPasswordLoginImage)
            }
        }
        if accountCheckResult == .valid && passwordCheckResult == .valid {
            
            let passwordHash = AuthManager.shared.sha256(password) // 將密碼進行SHA-256加密
            
            let url = URL(string: ServerApiHelper.shared.loginUserUrl)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let params = "Account=\(account)&Password=\(passwordHash)"
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
                            AuthManager.shared.saveUserAccountToKeychain(account: account)
                            AuthManager.shared.saveUserPasswordToKeychain(password: password)
                            // 切換到下一個畫面
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // 使用者已經登入
                            UserDataManager.shared.fetchUserData{ error in
                                if let error = error {
                                    // 處理錯誤情況，例如顯示錯誤訊息
                                    print("無法獲取用戶資料，錯誤：\(error.localizedDescription)")
                                } else {
                                    // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                                    print("用戶資料下載成功：\(UserDataManager.shared.userData)")
                                }
                            }
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                if let window = windowScene.windows.first {
                                    guard let StartVC = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as? StartVC else {
                                        return
                                    }
                                    let mainController = StartVC
                                    // Set the main view controller as the root view controller of the window
                                    window.rootViewController = mainController
                                    // Make the window key and visible
                                    window.makeKeyAndVisible()
                                }
                            }
                            
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


