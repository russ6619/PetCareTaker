//
//  RegisterVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit
import CryptoKit
import MapKit


class RegisterVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var testText: UITextField!
    
    @IBOutlet weak var userPhoneNB: UITextField!
    @IBOutlet weak var userPassWord: PasswordTextField!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userLivingArea: UIPickerView!
    
    @IBOutlet weak var checkForPhone: UILabel!
    
    @IBOutlet weak var checkForPassword: UILabel!
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    static let apiUrlString = "http://localhost:8888/PetCareTakerServer/"
    let registerUserURL = apiUrlString + "registerUser.php"
    
    
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
        
        guard let phone = userPhoneNB.text,
              let inputPassword = userPassWord.text,
              let name = userName.text else {
            return
        }
        
        let password = userPassWord.text ?? ""
        let passwordCheckResult = checkPassword(password)
        let account = userPhoneNB.text ?? ""
        let accountCheckResult = checkAccountCorrection(account)
        
        if accountCheckResult != .valid {
            switch accountCheckResult {
            case .valid:
                print("電話號碼輸入成功")
            case .lackDigits:
                print("電話號碼只能是數字")
                checkForPhone.text = "電話號碼只能是數字"
                accountLoginErrorUpdateUI()
            case .empty:
                print("電話號碼沒有輸入內容")
                checkForPhone.text = "電話號碼欄位不能空白"
                accountLoginErrorUpdateUI()
            case .lackAccountTextLength:
                print("電話號碼位數不正確")
                checkForPhone.text = "電話號碼位數不正確"
                accountLoginErrorUpdateUI()
            case .lackCorrection:
                print("電話號碼格式不正確")
                checkForPhone.text = "電話號碼格式不正確，需輸入數字，例如：0912345678"
                accountLoginErrorUpdateUI()
            default:
                break
            }
        } else if accountCheckResult == .valid {
            print("電話號碼輸入成功")
            accountLoginSuccessUpdateUI()
            customTextFieldStyle()
        }

        
        switch passwordCheckResult {
        case .valid:
            print("密碼符合輸入標準")
            passwordLoginSuccessUpdateUI()
            customTextFieldStyle()
        case .containsCommonPassword:
            print("密碼是共同密碼，建議更換")
            checkForPassword.text = "密碼是共同密碼，建議更換"
            passwordLoginErrorUpdateUI()
        case .lacksDigits:
            print("密碼少了數字")
            checkForPassword.text = "密碼少了數字"
            passwordLoginErrorUpdateUI()
        case .lacksPunctuation:
            print("密碼少了符號")
            checkForPassword.text = "密碼少了符號"
            passwordLoginErrorUpdateUI()
        case .lackTextLength:
            print("密碼長度需要在16至30字數之間")
            checkForPassword.text = "密碼長度需要在16至30個數字之間"
            passwordLoginErrorUpdateUI()
        case .empty:
            print("密碼欄位不能空白")
            checkForPassword.text = "密碼欄位不能空白"
            passwordLoginErrorUpdateUI()
            
        }
        
        if accountCheckResult != .valid {
            accountLoginErrorUpdateUI()
        }
        
        if passwordCheckResult == .valid {
            passwordLoginErrorUpdateUI()
        }
        
        if accountCheckResult == .valid && passwordCheckResult == .valid {
            // 對密碼進行 SHA-256 加密
            let encryptedPassword = sha256(inputPassword)
            
            // 獲取選擇的縣市名稱
            let selectedCityRow = userLivingArea.selectedRow(inComponent: 0)
            let residenceArea = taiwanCities[selectedCityRow]
            
            let userInfo = UserInfo(phone: phone, password: encryptedPassword, name: name, residenceArea: residenceArea)
            
            do {
                let jsonData = try JSONEncoder().encode(userInfo)
                
                let url = URL(string: registerUserURL)!
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
                        // ... 處理錯誤的提示
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
                                self.showAlert(title: "註冊失敗", message: "無法註冊新使用者")
                                print("Response: \(responseString)")
                            }
                        }
                    } else  {
                        // 處理伺服器回應的錯誤
                        self.showAlert(title: "註冊失敗", message: "伺服器回應錯誤")
                    }
                }
                task.resume()
            } catch {
                print(error)
            }
        }
    }
    
    // SHA-256 加密函式
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashedString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashedString
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
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

extension RegisterVC:UITextFieldDelegate {
    
    func checkAccountCorrection(_ account: String) -> AccountCheck {
        let digits = "0123456789"
        
        if account.count != 10 { return .lackAccountTextLength }
        if account.isEmpty { return .empty }
        if !account.allSatisfy({ digits.contains($0) }) { return .lackDigits }
        else { return .valid }
    }


    
    func checkPassword(_ password: String) -> PasswordCheck {
        let tenCommonPasswords = ["123456", "123456789", "qwerty", "password", "12345678", "111111", "iloveyou", "1q2w3e", "123123", "password1", "000000"]
        let digits = "0123456789"
        let punctuation = "!@#$%^&*(),.<>;'`~[]{}\\|/?_-+= "
        let textLength = Int(userPassWord.text?.count ?? 0)
        
        if tenCommonPasswords.contains(password) { return .containsCommonPassword }
        else if textLength == 0 { return .empty }
        else if !password.contains(where: { digits.contains($0) }) { return .lacksDigits }
        else if !password.contains(where: { punctuation.contains($0) }) { return.lacksPunctuation }
        else if textLength < 16 && textLength > 30 { return .lackTextLength }
        else  { return .valid }
    }
    
    //add left side of line for OrLoginWith
    func addLine() {
        let lineView = UIView(frame: CGRect(x: 31, y: 590, width: 100, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        self.view.addSubview(lineView)
        //add right side of line for OrLoginWith
        let secondLineView = UIView(frame: CGRect(x: 261, y: 590, width: 100, height: 1))
        secondLineView.layer.borderWidth = 1.0
        secondLineView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        self.view.addSubview(secondLineView)
    }
    
    //Set up placeholder
    func customPlaceholderUI() {
        //Enter your email
        let placeholderText = " Enter your email"
        userPhoneNB.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 131/255, green: 145/255, blue: 161/255, alpha: 1)])
        //Enter your password
        let secondPlaceholderText = " Enter your password"
        userPhoneNB.attributedPlaceholder = NSAttributedString(string: secondPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 131/255, green: 145/255, blue: 161/255, alpha: 1)])
    }
    
    func accountLoginErrorUpdateUI () {
        let placeholderText = " Enter your phone"
        userPhoneNB.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        userPhoneNB.layer.borderWidth = 1
        userPhoneNB.layer.borderColor = UIColor.systemRed.cgColor
        
        userPhoneNB.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 244/255, alpha: 1)
        checkForPhone.textColor = .systemRed
        checkForPhone.isHidden = false
        accountImageView.isHidden = false
        accountImageView.image = UIImage(systemName: "x.circle.fill")
        accountImageView.tintColor = .systemRed
    }
    
    func accountLoginSuccessUpdateUI () {
        checkForPhone.text = "帳號是有效的"
        checkForPhone.isHidden = false
        checkForPhone.textColor = .systemGreen
        checkForPassword.isHidden = true
        accountImageView.isHidden = false
        accountImageView.image =  UIImage(systemName: "checkmark.circle.fill")
        accountImageView.tintColor = .systemGreen
    }
    
    func passwordLoginErrorUpdateUI () {
        let secondPlaceholderText = " Enter your password"
        userPassWord.attributedPlaceholder = NSAttributedString(string: secondPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        userPassWord.layer.borderWidth = 1
        userPassWord.layer.borderColor = UIColor.systemRed.cgColor
        userPassWord.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 244/255, alpha: 1)
        checkForPassword.textColor = .systemRed
        checkForPassword.isHidden = false
        passwordImageView.isHidden = false
        passwordImageView.image = UIImage(systemName: "x.circle.fill")
        passwordImageView.tintColor = .systemRed
    }
    
    func passwordLoginSuccessUpdateUI () {
        checkForPassword.text = "密碼是有效的"
        checkForPassword.isHidden = false
        checkForPassword.textColor = .systemGreen
        checkForPassword.isHidden = true
        passwordImageView.isHidden = false
        passwordImageView.image = UIImage(systemName: "checkmark.circle.fill")
        passwordImageView.tintColor = .systemGreen
    }
    
    // 並在`customTextFieldStyle()`裡使用擴展方法
    func customTextFieldStyle() {
        userPhoneNB.setupTextFieldStyle()
        userPassWord.setupTextFieldStyle()
    }
}



extension UITextField {
    func setupTextFieldStyle() {
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 249/255, alpha: 1)
    }
}

enum AccountCheck {
    case valid
    case lackWord
    case lackDigits
    case lackCorrection
    case lackAccountTextLength
    case empty
}

enum PasswordCheck {
    case valid
    case containsCommonPassword
    case lacksDigits
    case lacksPunctuation
    case lackTextLength
    case empty
}
