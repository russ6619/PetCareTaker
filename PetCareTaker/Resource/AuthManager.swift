//
//  AuthManager.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/26.
//

import Foundation
import CryptoKit
import UIKit
import KeychainAccess

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    // 增加 isUserLoggedIn 屬性，預設為 false
    var isUserLoggedIn: Bool {
        get { return UserDefaults.standard.bool(forKey: "isUserLoggedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "isUserLoggedIn") }
    }
    
    // Keychain
    private let keychain = Keychain(service: "com.Russ.PetCareTaker")
    
    // 檢查 Phone/帳號 的格式
    func checkAccountCorrection(_ account: String) -> AccountCheck {
        let digits = "0123456789"
        
        if account.isEmpty { return .empty }
        else if account.count != 10 { return .lackAccountTextLength }
        else if !account.allSatisfy({ digits.contains($0) }) { return .lackDigits }
        else { return .valid }
    }
    
    // 檢查密碼的格式
    func checkPassword(_ password: String) -> PasswordCheck {
        let tenCommonPasswords = ["123456", "123456789", "qwerty", "password", "12345678", "111111", "iloveyou", "1q2w3e", "123123", "password1", "000000"]
        let digits = "0123456789"
        let punctuation = "!@#$%^&*(),.<>;’`~[]{}\\|/?_-+="
        let textLength = password.count
        
        if tenCommonPasswords.contains(password) { return .containsCommonPassword }
        else if textLength == 0 { return .empty }
        else if !password.contains(where: { digits.contains($0) }) { return .lacksDigits }
        else if !password.contains(where: { punctuation.contains($0) }) { return.lacksPunctuation }
        else if textLength < 10 || textLength > 30 { return .lackTextLength }
        else  { return .valid }
    }
    
    // 密碼加密
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashedString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashedString
    }
    
    // 帳密輸入格式檢查
    func checkAndResult(account: AccountCheck, password: PasswordCheck) -> (accountResult: String, passwordResult: String) {
        
        var accountResult = "格式有效"
        var passwordResult = "格式有效"
        
        if account != .valid {
            switch account {
            case .lackDigits:
                accountResult = "電話號碼只能是數字"
            case .empty:
                accountResult = "電話號碼欄位不能空白"
            case .lackAccountTextLength:
                accountResult = "電話號碼位數不正確"
            case .lackCorrection:
                accountResult = "電話號碼格式不正確，需輸入數字，例如：0912345678"
            default:
                break
            }
        }
        
        if password != .valid {
            switch password {
            case .containsCommonPassword:
                passwordResult = "密碼是共同密碼，建議更換"
            case .lacksDigits:
                passwordResult = "密碼少了數字"
            case .lacksPunctuation:
                passwordResult = "密碼少了符號"
            case .lackTextLength:
                passwordResult = "密碼長度需要在10至30個數字之間"
            case .empty:
                passwordResult = "密碼欄位不能空白"
            default:
                break
            }
        }
        return (accountResult, passwordResult)
    }
    
    // 帳號格式錯誤的顯示，請帶入帳號TextField、Label、imageView
    func accountLoginErrorUpdateUI(accountTextField: UITextField, accountLabel: UILabel, accountImage: UIImageView) {
        accountTextField.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 244/255, alpha: 1)
        accountLabel.textColor = .systemRed
        accountLabel.isHidden = false
        accountImage.isHidden = false
        accountImage.image = UIImage(systemName: "x.circle.fill")
        accountImage.tintColor = .systemRed
    }
    // 帳號格式正確的顯示，請帶入帳號Label、imageView
    func accountLoginSuccessUpdateUI (accountLabel: UILabel, accountImage: UIImageView) {
        accountLabel.text = "帳號格式有效"
        accountLabel.isHidden = false
        accountLabel.textColor = .systemGreen
        accountImage.isHidden = false
        accountImage.image =  UIImage(systemName: "checkmark.circle.fill")
        accountImage.tintColor = .systemGreen
    }
    // 密碼格式錯誤的顯示，請帶入密碼TextField、Label、imageView
    func passwordLoginErrorUpdateUI (passwordTextField: UITextField, passwordLabel: UILabel, passwordImage: UIImageView) {
        
        passwordTextField.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 244/255, alpha: 1)
        passwordLabel.textColor = .systemRed
        passwordLabel.isHidden = false
        passwordImage.isHidden = false
        passwordImage.image = UIImage(systemName: "x.circle.fill")
        passwordImage.tintColor = .systemRed
    }
    // 密碼格式錯誤的顯示，請帶入密碼Label、imageView
    func passwordLoginSuccessUpdateUI (passwordLabel: UILabel, passwordImage: UIImageView) {
        passwordLabel.text = "密碼格式有效"
        passwordLabel.isHidden = false
        passwordLabel.textColor = .systemGreen
        passwordImage.isHidden = false
        passwordImage.image = UIImage(systemName: "checkmark.circle.fill")
        passwordImage.tintColor = .systemGreen
    }
    // 將帳號密碼輸入欄重設為預設狀態
    func customTextFieldStyle(accountTextField: UITextField, passwordTextField: UITextField) {
        accountTextField.setupTextFieldStyle()
        passwordTextField.setupTextFieldStyle()
    }
    
    // 存儲用戶帳號到 Keychain
    func saveUserAccountToKeychain(account: String) {
        do {
            try keychain.set(account, key: "userAccount")
        } catch {
            print("Error saving user account to Keychain: \(error)")
        }
    }
    // 存儲用戶密碼到 Keychain
    func saveUserPasswordToKeychain(password: String) {
        do {
            try keychain.set(password, key: "userPassword")
        } catch {
            print("Error saving user password to Keychain: \(error)")
        }
    }
    
    // 檢索用戶帳號從 Keychain
    func getUserAccountFromKeychain() -> String? {
        do {
            return try keychain.getString("userAccount")
        } catch {
            print("Error retrieving user account from Keychain: \(error)")
            return nil
        }
    }
    // 檢索用戶密碼從 Keychain
    func getUserPasswordFromKeychain() -> String? {
        do {
            return try keychain.getString("userPassword")
        } catch {
            print("Error retrieving user password from Keychain: \(error)")
            return nil
        }
    }
    
    // 登出
    func logOut(completion: @escaping (Bool) -> Void) {
        // 清除用戶登入狀態
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        
        // 清除 Keychain 中的用戶帳號和密碼
        do {
            try keychain.remove("userAccount")
            try keychain.remove("userPassword")
            
            completion(true)
        } catch {
            print("Error removing user account/password from Keychain: \(error)")
            completion(false)
        }
    }
    
    // 跳轉到登入畫面
    func redirectToLogin() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    window.rootViewController = loginVC
                } else {
                    // 如果沒有窗口，創建一個新的窗口
                    let newWindow = UIWindow(windowScene: windowScene)
                    newWindow.rootViewController = loginVC
                    newWindow.makeKeyAndVisible()
                }
            }
        }
    }

}

// 以下是作為輸入檢查的各種情況
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

