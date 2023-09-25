import UIKit

class PetTabViewController: UIViewController {
    
    
    
    private let petTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    var petsImages = [String: UIImage]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDataManager.shared.petsData = UserDataManager.shared.petsData.filter { $0.petID != "" }
        petTable.reloadData()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        guard let imageUrl = URL(string: ServerApiHelper.shared.imageUrlString) else {
            return
        }
        // 使用 petID 來設置圖像
        UserDataManager.shared.downloadImage(from: imageUrl) { (result) in
            switch result {
            case .success((let image, let fileName)):
                // 在這裡使用下載的圖片和檔案名稱
                // 在這裡使用下載的圖片和檔案名稱
                if let petID = self.getPetIDForImage(fileName) {
                    // 使用 petID 作為鍵來設置圖像
                    self.petsImages[petID] = image
                    // 刷新表格視圖
                    self.petTable.reloadData()
                }
                print("下載的檔案名稱: \(fileName)")
            case .failure(let error):
                // 下載圖片失敗，處理錯誤
                print("下載失敗: \(error.localizedDescription)")
            }
        }

    }
    
    private func getPetIDForImage(_ fileName: String) -> String? {
        // 尋找 "petsImageWith" 的範圍
        if let range = fileName.range(of: "petsImageWith") {
            // 提取 "petsImageWith" 之後的部分，這部分應該是寵物ID
            let petIDPart = fileName[range.upperBound...]
            
            // 將提取的部分轉換為字符串並返回
            return String(petIDPart)
        }
        
        // 如果未找到 "petsImageWith"，返回 nil
        return nil
    }

    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 創建並設置 tableView
        petTable.dataSource = self
        petTable.delegate = self
        petTable.frame = view.bounds // 確保 tableView 填滿整個視圖
        petTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 註冊 PetTableViewCell 類別用於表視圖
        petTable.register(PetTableViewCell.self, forCellReuseIdentifier: "PetCell")
        
        // 添加 tableView 到視圖中
        view.addSubview(petTable)
        
    }
    @objc func addButtonTapped() {
//        if UserDataManager.shared.petsData.
        // 創建一個新的空白寵物資料
        let newPet = Pet(petID: "", name: "寵物名稱", gender: "寵物性別", type: "品種", birthDate: "出生日期", size: "尺寸", neutered: "是否結紮", vaccinated: "是否規律施打疫苗", personality: "個性", photo: "", precautions: "寵物注意事項或介紹")
        
        // 將新的寵物資料添加到 petsData 中
        UserDataManager.shared.petsData.append(newPet)
        
        // 跳轉到 PetInformationEditVC，並將選定的寵物設置為新建立的寵物
        let petInformationEditVC = PetInformationEditVC()
        petInformationEditVC.selectedPet = newPet
        navigationController?.pushViewController(petInformationEditVC, animated: true)
    }


    
    
}

// MARK: tableview
extension PetTabViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回寵物數據的總數
        return UserDataManager.shared.petsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetTableViewCell
        
        // 獲取特定位置的寵物數據
        let pet = UserDataManager.shared.petsData[indexPath.row]
        
        // 使用 configure 方法設置單元格的內容
        cell.configure(with: pet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 當用戶點擊單元格時，執行以下代碼
        let petInformationEditVC = PetInformationEditVC() // 創建PetInformationEditVC實例
        let selectedPet = UserDataManager.shared.petsData[indexPath.row]
        let selectedPetID = UserDataManager.shared.petsData[indexPath.row].petID
        let selectedPetNowImage = petsImages[selectedPetID]
        petInformationEditVC.selectedPet = selectedPet // 設置選定的寵物信息
        petInformationEditVC.selectedPetID = selectedPetID
        petInformationEditVC.petNowImage.image = selectedPetNowImage
        
        navigationController?.pushViewController(petInformationEditVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedPet = UserDataManager.shared.petsData[indexPath.row]
            let alertController = UIAlertController(title: "確認刪除", message: "您確定要刪除這個寵物嗎？", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { (action) in
                // 在這裡執行刪除操作
                let petID_to_delete = Int(selectedPet.petID)!
                
                guard let deletePetURL = URL(string: "\(ServerApiHelper.shared.deletePetUrl)?PetID=\(petID_to_delete)") else {
                    return
                }
                
                var request = URLRequest(url: deletePetURL)
                request.httpMethod = "DELETE"
                
                // 發送請求
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let success = jsonResponse["success"] as? Bool,
                               let message = jsonResponse["message"] as? String,
                               let debugInfo = jsonResponse["debugInfo"] as? [String: Any] {
                                if success {
                                    // 刪除成功，從 petsData 中刪除對應的寵物資訊
                                    if let debugPetID = debugInfo["要刪除的 PetID"] as? Int {
                                        print("要刪除的 PetID: \(debugPetID)")
                                    }
                                    let indexToDelete = UserDataManager.shared.petsData.firstIndex { $0.petID == selectedPet.petID }
                                    if let indexToDelete = indexToDelete {
                                        UserDataManager.shared.petsData.remove(at: indexToDelete)
                                    }
                                    
                                    // 刷新 UI（例如，重新載入 tableView）
                                    DispatchQueue.main.async {
                                        // 在主執行緒中更新 UI
                                        tableView.reloadData()
                                    }
                                } else {
                                    // 刪除失敗，可能顯示錯誤訊息給使用者
                                    print("刪除失敗：\(message)")
                                }
                            }
                        } catch let error {
                            print("JSON parsing error: \(error.localizedDescription)")
                        }
                    }
                }
                task.resume()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    
}
