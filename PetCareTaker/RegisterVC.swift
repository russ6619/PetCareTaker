//
//  RegisterVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit
import CryptoKit


class RegisterVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var testText: UITextField!
    
    @IBOutlet weak var userPhoneNB: UITextField!
    @IBOutlet weak var userPassWord: PasswordTextField!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userLivingArea: UIPickerView!
    
    @IBOutlet weak var checkForPhone: UILabel!
    @IBOutlet weak var checkForPassword: UILabel!
    @IBOutlet weak var checkForUserName: UILabel!
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    
    let taiwanCities = ["基隆市", "台北市", "新北市", "桃園市", "新竹市", "新竹縣", "苗栗縣", "台中市", "彰化縣", "南投縣", "雲林縣", "嘉義市", "嘉義縣", "台南市", "高雄市", "屏東縣", "台東縣", "花蓮縣", "金門縣", "連江縣", "澎湖縣"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLivingArea.dataSource = self
        userLivingArea.delegate = self
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taiwanCities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taiwanCities[row]
    }
    
    
    @IBAction func petInformation(_ sender: Any) {
    }
    
    @IBAction func checkRegister(_ sender: Any) {
        
        guard let account = userPhoneNB.text,
              let password = userPassWord.text,
              let name = userName.text else {
            return
        }
        
        let accountCheckResult = AuthenticationManager.shared.checkAccountCorrection(account)
        let passwordCheckResult = AuthenticationManager.shared.checkPassword(password)
        
        let allCheckText = AuthenticationManager.shared.checkAndResult(account: accountCheckResult, password: passwordCheckResult)
        
        checkForPhone.text = allCheckText.accountResult
        checkForPassword.text = allCheckText.passwordResult
        
        if allCheckText.accountResult == "格式有效" {
            DispatchQueue.main.async {
                AuthenticationManager.shared.accountLoginSuccessUpdateUI(accountLabel: self.checkForPhone, accountImage: self.accountImageView)
            }
        } else {
            print("\(allCheckText.accountResult)")
            DispatchQueue.main.async {
                AuthenticationManager.shared.accountLoginErrorUpdateUI(accountTextField: self.userPhoneNB, accountLabel: self.checkForPhone, accountImage: self.accountImageView)
            }
        }
        
        if allCheckText.passwordResult == "格式有效" {
            DispatchQueue.main.async {
                AuthenticationManager.shared.passwordLoginSuccessUpdateUI(passwordLabel: self.checkForPassword, passwordImage: self.passwordImageView)
                
            }
        } else {
            DispatchQueue.main.async {
                AuthenticationManager.shared.passwordLoginErrorUpdateUI(passwordTextField: self.userPassWord, passwordLabel: self.checkForPassword, passwordImage: self.passwordImageView)
            }
        }
        
        // 檢查 name 是否為空
        if name.isEmpty {
            print("名稱不能為空")
            checkForUserName.text = "名稱不能為空"
            checkForUserName.textColor = .systemRed
            userName.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 244/255, alpha: 1)
            return
        } else {
            checkForUserName.text = "名稱有效"
            checkForUserName.textColor = .systemGreen
            userName.setupTextFieldStyle()
        }
        
        if accountCheckResult == .valid && passwordCheckResult == .valid && !name.isEmpty {
            // 對密碼進行 SHA-256 加密
            let encryptedPassword = AuthenticationManager.shared.sha256(password)
            
            // 獲取選擇的縣市名稱
            let selectedCityRow = userLivingArea.selectedRow(inComponent: 0)
            let residenceArea = taiwanCities[selectedCityRow]
            
            let userInfo = UserInfo(phone: account, password: encryptedPassword, name: name, residenceArea: residenceArea)
            
            do {
                let jsonData = try JSONEncoder().encode(userInfo)
                
                let url = URL(string: ServerApiHelper.shared.registerUserURL)!
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
                        self.showAlert(title: "註冊失敗", message: "無法連線到伺服器")
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
                                self.showAlert(title: "註冊成功", message: "您已成功註冊帳號")
                            } else {
                                // 註冊失敗
                                self.showAlert(title: "註冊失敗", message: "\(responseString)")
                                print("Response: \(responseString)")
                            }
                        }
                    } else  {
                        self.showAlert(title: "註冊失敗", message: "伺服器回應錯誤")
                    }
                }
                task.resume()
            } catch {
                print(error)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
                    // 使用者按下「確定」後，切換畫面
                    self.navigationController?.popViewController(animated: true)
                })
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}


struct UserInfo: Codable {
    var phone: String
    var password: String
    var name: String
    var residenceArea: String
    
    enum CodingKeys: String, CodingKey {
        case phone = "Phone"
        case password = "Password"
        case name = "Name"
        case residenceArea = "ResidenceArea"
    }
    
}
