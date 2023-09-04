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
        print(AuthManager.shared.isUserLoggedIn)
        if AuthManager.shared.isUserLoggedIn {
            // 使用者已經登入，從Keychain中獲取帳號和密碼
            if let storedAccount = AuthManager.shared.getUserAccountFromKeychain(),
               let storedPassword = AuthManager.shared.getUserPasswordFromKeychain() {
                print("Acc: \(storedAccount), Pas: \(storedPassword)")
                // 執行帳號和密碼比對
                checkLogin(account: storedAccount, password: storedPassword) { success in
                    if !success {
                        // 比對失敗，跳轉到登入畫面
                        self.redirectToLogin()
                    }
                }
            } else {
                // Keychain中沒有存儲帳號和密碼，跳轉到登入畫面
                redirectToLogin()
                print("Keychain中沒有存儲帳號和密碼，跳轉到登入畫面")
            }
        } else {
            // 使用者尚未登入，執行切換到登入畫面的操作
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
                return
            }
            if let data = data,
               let result = String(data: data, encoding: .utf8) {
                print("result: \(result)")
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

    
    // 設置已登入的畫面
    func setupLoggedInUI() {
        // 在這裡設置已登入的畫面，可能是TabBar等
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

