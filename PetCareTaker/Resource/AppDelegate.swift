//
//  AppDelegate.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 檢查使用者是否已經登入
        //        print(AuthManager.shared.isUserLoggedIn)
        if AuthManager.shared.isUserLoggedIn {
            // 使用者已經登入，從Keychain中獲取帳號和密碼
            if let storedAccount = AuthManager.shared.getUserAccountFromKeychain(),
               let storedPassword = AuthManager.shared.getUserPasswordFromKeychain() {
                //                print("Acc: \(storedAccount), Pas: \(storedPassword)")
                // 執行帳號和密碼比對
                checkLogin(account: storedAccount, password: storedPassword) { success in
                    if !success {
                        // 比對失敗，跳轉到登入畫面
                        AuthManager.shared.redirectToLogin()
                    } else {
                        DispatchQueue.main.async {
                            // 更新畫面程式
                            self.loginSetupData()
                        }
                    }
                }
            } else {
                // Keychain中沒有存儲帳號和密碼，跳轉到登入畫面
                AuthManager.shared.redirectToLogin()
                print("Keychain中沒有存儲帳號和密碼，跳轉到登入畫面")
            }
        } else {
            // 使用者尚未登入，執行切換到登入畫面的操作
            AuthManager.shared.redirectToLogin()
        }
        return true
    }
    
    // 檢查帳號和密碼是否正確
    func checkLogin(account: String, password: String, completion: @escaping (Bool) -> Void) {
        let passwordHash = AuthManager.shared.sha256(password) // 將密碼進行SHA-256加密
        
        let url = URL(string: ServerApiHelper.shared.loginUserUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = "Phone=\(account)&Password=\(passwordHash)"
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false) // 請求失敗，回傳 false
                // 在這裡顯示連接錯誤警告
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "連線錯誤", message: "無法連接到伺服器。請檢查您的網路連接或伺服器設定。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                return
            }
            if let data = data,
               let result = String(data: data, encoding: .utf8) {
                //                print("result: \(result)")
                // 根據 result 的值來判斷帳號和密碼是否正確
                if result == "true" {
                    completion(true) // 帳號和密碼正確，回傳 true
                } else {
                    completion(false) // 帳號和密碼不正確，回傳 false
                }
            }
        }
        task.resume()
    }
    
    
    // 登入成功設定資料
    func loginSetupData() {
        // 在這裡設置已登入者的資料，個人資料等等...
        UserDataManager.shared.fetchUserData { error in
            if let error = error {
                // 處理錯誤情況，例如顯示錯誤訊息
                print("無法獲取用戶資料，錯誤：\(error.localizedDescription)")
            } else {
                // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                print("用戶資料下載成功：\(UserDataManager.shared.userData)")
                
                // 如果成功下載用戶資料，獲取用戶的 userID
                guard let userID: String = UserDataManager.shared.userData["UserID"] as? String else { return }
                
                // 使用 userID 調用 fetchUserPetData 來下載用戶的寵物資料
                UserDataManager.shared.fetchUserPetData(userID: userID) { error in
                    if let error = error {
                        // 處理錯誤情況，例如顯示錯誤訊息
                        print("無法獲取用戶寵物資料，錯誤：\(error.localizedDescription)")
                    } else {
                        // 寵物資料下載成功，可以在這裡處理用戶寵物資料，例如設定 userPetData
                        print("用戶寵物資料下載成功：\(UserDataManager.shared.petsData)")
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


