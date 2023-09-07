//
//  RegisterVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit
import CryptoKit


class RegisterVC: UIViewController {
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
    
    var cities: [City] = []  // 解析後的資料陣列
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLivingArea.dataSource = self
        userLivingArea.delegate = self
        
        // 解析 JSON 資料並賦值給 cities 陣列
        if let data = NSDataAsset(name: "taiwanDistricts")?.data {
            do {
                cities = try JSONDecoder().decode([City].self, from: data)
                userLivingArea.reloadAllComponents()  // 重新載入 UIPickerView
            } catch {
                print("JSON decoding error: \(error)")
            }
        }
    }
    
    
    
    @IBAction func petInformation(_ sender: Any) {
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
            let encryptedPassword = AuthManager.shared.sha256(password)
            
            // 獲取選擇的縣市名稱
            let selectedCityRow = userLivingArea.selectedRow(inComponent: 0)
            // 確認選定的城市在範圍內
            if selectedCityRow < cities.count {
                let selectedCity = cities[selectedCityRow]
                
                // 獲取選擇的行政區名稱
                let selectedDistrictRow = userLivingArea.selectedRow(inComponent: 1)
                // 確認選定的行政區在範圍內
                if selectedDistrictRow < selectedCity.districts.count {
                    let selectedDistrict = selectedCity.districts[selectedDistrictRow]
                    
                    let residenceArea = "\(selectedCity.name) - \(selectedDistrict.name)"
                    
                    
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
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
                //                    if // 使用者按下「確定」後，切換畫面
                //                    self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}

// MARK: PickerView
extension RegisterVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cities.count
        } else {
            let cityRow = pickerView.selectedRow(inComponent: 0)
            return cities[cityRow].districts.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cities[row].name
        } else {
            let cityRow = pickerView.selectedRow(inComponent: 0)
            return cities[cityRow].districts[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1) // 重新載入第二個組件
            pickerView.selectRow(0, inComponent: 1, animated: true) // 選擇第二個組件的第一行
            pickerView.isUserInteractionEnabled = false // 禁用整個PickerView的交互
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

struct City: Codable {
    let name: String
    let districts: [District]
}

struct District: Codable {
    let zip: String
    let name: String
}
