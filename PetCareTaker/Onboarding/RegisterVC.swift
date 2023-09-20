//
//  RegisterVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit
import CryptoKit


class RegisterVC: UIViewController {
    
    @IBOutlet weak var userPhoneNB: UITextField!
    @IBOutlet weak var userPassWord: PasswordTextField!
    @IBOutlet weak var userName: UITextField!
    
    
    @IBOutlet weak var checkForPhone: UILabel!
    @IBOutlet weak var checkForPassword: UILabel!
    @IBOutlet weak var checkForUserName: UILabel!
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    @IBOutlet weak var livingAreaLabel: UILabel!
    
    var cities: [City] = []  // 解析後的資料陣列
    var cityMenuItems: [UIMenuElement] = []
    var residenceArea: String = ""
    
    private let livingAreaMenuBtn: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.setTitleColor(.label, for: .normal)
        button.menu = UIMenu(children: [
            UIAction(title: "臺北市", handler: { action in
                print("臺北市")})
        ])
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(livingAreaMenuBtn)
        
        
        // 解析 JSON 資料並賦值給 cities 陣列
        if let data = NSDataAsset(name: "taiwanDistricts")?.data {
            do {
                cities = try JSONDecoder().decode([City].self, from: data)
            } catch {
                print("JSON decoding error: \(error)")
            }
        }
        
        // 遍歷城市列表
        for city in cities {
            // 創建城市的子菜單
            var districtMenuItems: [UIMenuElement] = []
            
            // 遍歷城市的區域
            for district in city.districts {
                // 創建區域的UIAction並添加到區域子菜單
                let districtAction = UIAction(title: city.name + "-" + district.name, handler: { action in
                    print("\(city.name) - \(district.name)")
                    self.residenceArea = "\(city.name) - \(district.name)"
                })
                districtMenuItems.append(districtAction)
            }
            
            // 創建城市的UIMenu，將區域子菜單作為子項添加
            let cityMenu = UIMenu(title: city.name, children: districtMenuItems)
            cityMenuItems.append(cityMenu)
        }
        
        // 創建最終的UIMenu，將城市菜單作為子項添加
        let finalMenu = UIMenu(title: "居住地", children: cityMenuItems)
        
        // 將最終的UIMenu設置為livingAreaMenuBtn的menu
        livingAreaMenuBtn.menu = finalMenu
        livingAreaMenuBtn.setTitle("請選擇居住地", for: .normal)
        
    }
    
    // 全部鍵盤都關掉dimiss,比較簡單跟常用
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 設定 livingAreaMenuBtn 位置，在 petTypeLabel 下方，水平置中
        livingAreaMenuBtn.frame = CGRect(
            x: view.xCenter - 75,
            y: livingAreaLabel.bottom,
            width: 150,
            height: 50)
        
    }
    
    
    @IBAction func checkRegister(_ sender: Any) {
        
        guard let account = userPhoneNB.text,
              let password = userPassWord.text,
              let name = userName.text else {
            return
        }
        
        let accountCheckResult = AuthManager.shared.checkAccountCorrection(account)
        let passwordCheckResult = AuthManager.shared.checkPassword(password)
        
        let allCheckText = AuthManager.shared.checkAndResult(account: accountCheckResult, password: passwordCheckResult)
        
        checkForPhone.text = allCheckText.accountResult
        checkForPassword.text = allCheckText.passwordResult
        
        if allCheckText.accountResult == "格式有效" {
            DispatchQueue.main.async {
                AuthManager.shared.accountLoginSuccessUpdateUI(accountLabel: self.checkForPhone, accountImage: self.accountImageView)
            }
        } else {
            print("\(allCheckText.accountResult)")
            DispatchQueue.main.async {
                AuthManager.shared.accountLoginErrorUpdateUI(accountTextField: self.userPhoneNB, accountLabel: self.checkForPhone, accountImage: self.accountImageView)
            }
        }
        
        if allCheckText.passwordResult == "格式有效" {
            DispatchQueue.main.async {
                AuthManager.shared.passwordLoginSuccessUpdateUI(passwordLabel: self.checkForPassword, passwordImage: self.passwordImageView)
                
            }
        } else {
            DispatchQueue.main.async {
                AuthManager.shared.passwordLoginErrorUpdateUI(passwordTextField: self.userPassWord, passwordLabel: self.checkForPassword, passwordImage: self.passwordImageView)
            }
        }
        
        // 檢查 name 是否為空
        if name.isEmpty {
            checkForUserName.text = "名稱不能為空"
            checkForUserName.textColor = .systemRed
            userName.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 244/255, alpha: 1)
            return
        } else {
            checkForUserName.text = "名稱有效"
            checkForUserName.textColor = .systemGreen
            userName.setupTextFieldStyle()
        }
        
        if residenceArea.isEmpty {
            showAlert(title: "請選擇居住地", message: "居住地不能為空")
        }
        
        if accountCheckResult == .valid && passwordCheckResult == .valid && !name.isEmpty && !residenceArea.isEmpty {
            // 對密碼進行 SHA-256 加密
            let encryptedPassword = AuthManager.shared.sha256(password)
            
            
                let userInfo = UserInfo(phone: account, password: encryptedPassword, name: name, residenceArea: residenceArea)
                
                
                do {
                    let jsonData = try JSONEncoder().encode(userInfo)
                    
                    let url = URL(string: ServerApiHelper.shared.registerUserUrl)!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData
                    
                    do {
                        let jsonData = try JSONEncoder().encode(userInfo)
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("JSON Data:\n\(jsonString)")
                        }
                    } catch {
                        print("Encoding JSON data error: \(error)")
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            // 發生錯誤，進行錯誤處理
                            print("Error: \(error)")
                            showAlert(title: "註冊失敗", message: "無法連線到伺服器")
                            return
                        }
                        
                        if let httpResponse = response as? HTTPURLResponse,
                           httpResponse.statusCode == 200,
                           let data = data {
                            // 伺服器回應正確，處理回傳的資料
                            print("HTTP Status Code: \(httpResponse.statusCode)")
                            if let responseString = String(data: data, encoding: .utf8) {
                                if responseString == "成功添加新使用者" {
                                    // 註冊成功
                                        let passwordHash = AuthManager.shared.sha256(password) // 將密碼進行SHA-256加密
                                        
                                        let url = URL(string: ServerApiHelper.shared.loginUserUrl)!
                                        var request = URLRequest(url: url)
                                        request.httpMethod = "POST"
                                        
                                        let params = "Phone=\(account)&Password=\(passwordHash)"
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
                                    showAlert(title: "註冊成功", message: "您已成功註冊帳號")
                                } else {
                                    // 註冊失敗
                                    showAlert(title: "註冊失敗", message: "\(responseString)")
                                    print("Response: \(responseString)")
                                }
                            }
                        } else  {
                            showAlert(title: "註冊失敗", message: "伺服器回應錯誤")
                        }
                    }
                    task.resume()
                } catch {
                    print(error)
                }
//            }
        }
        
        
        
        func showAlert(title: String, message: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
                })
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}


