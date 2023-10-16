//
//  StartVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/19.
//

import UIKit

class StartVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // 檢查使用者是否已經登入
        DispatchQueue.main.async {
            if AuthManager.shared.isUserLoggedIn {
                // 使用者已經登入，從Keychain中獲取帳號和密碼
                if let storedAccount = AuthManager.shared.getUserAccountFromKeychain(),
                   let storedPassword = AuthManager.shared.getUserPasswordFromKeychain() {
                    print("Acc: \(storedAccount), Pas: \(storedPassword)")
                    // 執行帳號和密碼比對
                    self.checkLogin(account: storedAccount, password: storedPassword) { success in
                        if !success {
                            // 比對失敗，跳轉到登入畫面
                            AuthManager.shared.redirectToLogin()
                        } else {
                            
                            // 更新畫面程式
                            self.loginSetupData()
                        }
                    }
                    
                    
                } else {
                    // Keychain中沒有存儲帳號和密碼，跳轉到登入畫面
                    AuthManager.shared.redirectToLogin()
                    print("Keychain中沒有存儲帳號和密碼，跳轉到登入畫面")
                }
                
            }else {
                // 使用者尚未登入，執行切換到登入畫面的操作
                AuthManager.shared.redirectToLogin()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        window.rootViewController?.present(alert, animated: true, completion: nil)
                    }
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
        UserDataManager.shared.fetchTaskData { error in
            if let error = error {
                print("無法獲取任務清單，錯誤：\(error.localizedDescription)")
            } else {
                // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                print("任務清單下載成功：\(UserDataManager.shared.tasksData)")
            }
        }
        print("fetchUserData開始")
        UserDataManager.shared.fetchUserData { error in
            if let error = error {
                // 處理錯誤情況，例如顯示錯誤訊息
                print("無法獲取用戶資料，錯誤：\(error.localizedDescription)")
            } else {
                // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                print("用戶資料下載成功：\(UserDataManager.shared.userData)")
                print("下載的userID: \(String(describing: UserDataManager.shared.userData["UserID"]))")
                // 如果成功下載用戶資料，獲取用戶的 userID
                let userID: String = String(UserDataManager.shared.userData["UserID"] as! Int)
                print("userID = \(userID)")
                // 下載使用者照片
                let uniqueFileName = "personImageWith\(userID).jpg"
                guard let imageUrl = URL(string: "\(ServerApiHelper.shared.imageUrlString)\(uniqueFileName)") else {
                    return
                }
//                print("URL: \(imageUrl)")
                DispatchQueue.main.async {
                    // 更新畫面程式
                    UserDataManager.shared.downloadImage(from: imageUrl) { (result) in
                        switch result {
                        case .success((let image, let fileName)):
                            // 在這裡使用下載的圖片和檔案名稱
                            UserDataManager.shared.userImage = image
                                // 刷新表格視圖
                            print("下載的檔案名稱: \(fileName)")
                        case .failure(let error):
                            // 下載圖片失敗，處理錯誤
                            let noImage = UIImage(systemName: "camera.circle.fill")!
                            noImage.withTintColor(.orange)
                            UserDataManager.shared.userImage = noImage
                            print("個人照片下載失敗: \(error.localizedDescription)")
                        }
                    }
                }
                print("fetchTaskDataFromID開始")
                UserDataManager.shared.fetchTaskDataFromID(publisherID: userID) { error in
                    if let error = error {
                        // 處理錯誤情況，例如顯示錯誤訊息
                        print("無法獲取用戶發佈的任務資料，錯誤：\(error.localizedDescription)")
                    } else {
                        // 寵物資料下載成功，可以在這裡處理用戶寵物資料，例如設定 userPetData
                        print("用戶任務資料下載成功：\(UserDataManager.shared.selfTaskData)")
                    }
                }
                print("fetchUserPetData開始")
                print("userID = \(userID)")
                // 使用 userID 調用 fetchUserPetData 來下載用戶的寵物資料
                UserDataManager.shared.fetchUserPetData(userID: userID) { error in
                    if let error = error {
                        // 處理錯誤情況，例如顯示錯誤訊息
                        print("無法獲取用戶寵物資料，錯誤：\(error.localizedDescription)")
                    } else {
                        // 寵物資料下載成功，可以在這裡處理用戶寵物資料，例如設定 userPetData
                        print("用戶寵物資料下載成功：\(UserDataManager.shared.petsData)")
                        
                        // 下載完成後，切換到主畫面
                        DispatchQueue.main.async {
                            // 創建主視圖控制器
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                if let window = windowScene.windows.first {
                                    guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainControllerVC") as? MainControllerVC else {
                                        return
                                    }
                                    let mainController = mainVC
                                    // Set the main view controller as the root view controller of the window
                                    window.rootViewController = mainController
                                    // Make the window key and visible
                                    window.makeKeyAndVisible()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
