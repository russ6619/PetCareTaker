//
//  UserDataManager.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/4.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()
    
    var userData = [String: Any]()
    
    var tasksData = [String: Any]()
    
    var petsData = [Pet]() // 存儲寵物對象的數組
    
    private init() {
        // 初始化，如果需要的話
    }
    
    // 下載個人資料
    func fetchUserData(completion: @escaping (Error?) -> Void) {
        // 使用 queryUserUrl 從 PHP 後端獲取用戶數據
        guard let userAccount = AuthManager.shared.getUserAccountFromKeychain(),
              let url = URL(string: ServerApiHelper.shared.queryUserUrl + "?Phone=" + userAccount) else {
            completion(NSError(domain: "UserDataManager", code: 400, userInfo: ["message": "無法獲取用戶帳號或建立 URL"]))
            return
        }
        
        // 創建 URL 請求
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 發起網絡請求
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // 解析從 PHP 後端返回的數據
            if let data = data {
                do {
                    if let userData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // 將用戶資料存儲到 UserDataManager 中
                        self.userData = userData
                        //                        print(self.userData)
                        completion(nil) // 成功下載並設定資料
                    }
                } catch {
                    completion(error)
                    print("JSON解析錯誤: \(error)")
                }
            }
        }.resume()
    }
    
    
    // 更新用戶資料
    func updateUserProfile(completion: @escaping (Error?) -> Void) {
        // 將要傳送的資料轉換為 JSON 格式
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            
            print("jsonData: \(jsonData)")
            // 建立 URL
            guard let url = URL(string: ServerApiHelper.shared.updateUserUrl) else {
                completion(NSError(domain: "UserDataManager", code: 400, userInfo: ["message": "無法建立 URL"]))
                return
            }
            
            // 創建 URL 請求
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // 發起網絡請求
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                // 檢查伺服器回應
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(nil) // 成功更新資料
                    } else {
                        completion(NSError(domain: "UserDataManager", code: httpResponse.statusCode, userInfo: ["message": "伺服器回應錯誤"]))
                    }
                }
            }.resume()
        } catch {
            completion(error)
            print("JSON轉換錯誤: \(error)")
        }
    }
    
    // 下載用戶寵物資料
    func fetchUserPetData(userID: String, completion: @escaping (Error?) -> Void) {
        // 使用 queryPetUrl 從 PHP 後端獲取用戶寵物數據，並包含 userID 參數
        guard let url = URL(string: ServerApiHelper.shared.queryPetUrl + "?userID=" + userID) else {
            completion(NSError(domain: "UserDataManager", code: 400, userInfo: ["message": "無法建立 URL"]))
            return
        }
        
        // 創建 URL 請求
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 發起網絡請求
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // 解析從 PHP 後端返回的數據
            
            if let data = data {
                do {
                    if let userPetData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        var pets = [Pet]()
                        for petData in userPetData {
                            if let petID = petData["PetID"] as? String,
                               let name = petData["Name"] as? String,
                               let gender = petData["Gender"] as? String,
                               let type = petData["Type"] as? String,
                               let breed = petData["Breed"] as? String,
                               let birthDate = petData["BirthDate"] as? String,
                               let size = petData["Size"] as? String,
                               let neutered = petData["Neutered"] as? String,
                               let vaccinated = petData["Vaccinated"] as? String,
                               let personality = petData["Personality"] as? String,
                               let habits = petData["Habits"] as? String,
                               let photo = petData["Photo"] as? String {
                                
                                let pet = Pet(petID: petID, name: name, gender: gender, type: type, breed: breed, birthDate: birthDate, size: size, neutered: neutered, vaccinated: vaccinated, personality: personality, habits: habits, photo: photo)
                                pets.append(pet)
                            }
                        }
                        
                        // 將寵物數據存儲在 UserDataManager 中
                        self.petsData = pets
                        completion(nil) // 成功下載並設定寵物資料
                    } else {
                        print("JSON 解析錯誤: 數據格式不正確")
                        print("data: \(data)")
                    }
                } catch let error {
                    print("JSON 解析錯誤: \(error)")
                }
            }
        }.resume()
    }
    
    
}

// 寵物結構
struct Pet {
    let petID: String
    let name: String
    let gender: String
    let type: String
    let breed: String
    let birthDate: String
    let size: String
    let neutered: String
    let vaccinated: String
    let personality: String
    let habits: String
    let photo: String
}
