//
//  TaskPublisherInfoVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/10/3.
//

import UIKit

class TaskPublisherInfoVC: UIViewController {
    
    var userInfo: UserData!
    var userPetsInfo: [PetData] = []
    var petsImages = [String: UIImage]()
    
    var userImage = UIImage()
        
    let personalImage = UIImage(systemName: "person.circle.fill")
    
    // 創建 UITableView
    private var userPetsTable: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 創建並設置 tableView
        userPetsTable.dataSource = self
        userPetsTable.delegate = self
        userPetsTable.frame = view.bounds // 確保 tableView 填滿整個視圖
        userPetsTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        userPetsTable.register(TaskPublisherInformationCell.self, forCellReuseIdentifier: "TaskPublisherInformationCell")
        // 註冊 PetTableViewCell 類別用於表視圖
        userPetsTable.register(PetTableViewCell.self, forCellReuseIdentifier: "PetCell")

        
        // 添加 tableView 到視圖中
        view.addSubview(userPetsTable)
        // 設定返回按鈕的標題
        let backButton = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
    }

    private func storeImage(_ image: UIImage?, forPetID petID: String) {
        if let image = image {
            petsImages[petID] = image
        }
    }
    
    @objc func reloadData() {
        
        guard let imageUrl = URL(string: ServerApiHelper.shared.apiUrlString) else {
            return
        }
        DispatchQueue.main.async { [self] in
            // 更新畫面程式
            for pet in self.userPetsInfo {
                if let photoURL = URL(string: "\(imageUrl)\(String(describing: pet.photo!))") {
                    print("任務petImageUrl = \(photoURL)")
                        UserDataManager.shared.downloadImage(from: photoURL) { (result) in
                            switch result {
                            case .success((let image, _)):
                                let petStringId = String(pet.petID!)
                                // 將下載的照片存儲在 petsImages 字典中，以 petID 作為鍵
                                self.petsImages[petStringId] = image
                                self.userPetsTable.reloadData() // 刷新表格視圖
                            case .failure(let error):
                                print("任務發佈者的寵物照片下載失敗: \(error.localizedDescription)")
                                self.userPetsTable.reloadData() // 刷新表格視圖
                            }
                        }
                    }
                }
            
            
            if let userInfoImage = self.userInfo.photo,
               let userPhotoURL = URL(string: "\(imageUrl)\(String(describing: userInfoImage))") {
                print("任務userImageUrl = \(userPhotoURL)")
                UserDataManager.shared.downloadImage(from: userPhotoURL) { (result) in
                    switch result {
                    case .success((let image, _)):
                        // 將下載的照片存儲在 petsImages 字典中，以 petID 作為鍵
                        self.userImage = image
                        self.userPetsTable.reloadData() // 刷新表格視圖
                    case .failure(let error):
                        print("任務發佈者的照片下載失敗: \(error.localizedDescription)")
                        self.userPetsTable.reloadData() // 刷新表格視圖
                    }
                }
            }
            userImage = self.personalImage!
        }
        
    }
    
}


// MARK: UITableView
extension TaskPublisherInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回寵物數據的總數
        if section == 0 {
            // 第一個部分顯示用戶信息，行數為 1
            return 1
        } else if section == 1 {
            // 第二個部分顯示寵物信息，行數為 userPetsInfo 的數據總數
            return userPetsInfo.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // 第一部分顯示使用者資訊
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPublisherInformationCell", for: indexPath) as! TaskPublisherInformationCell

            cell.configure(with: userInfo, image: userImage)
            
            return cell
        } else if indexPath.section == 1 {
            // 第二部分顯示寵物資訊
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetTableViewCell
            
            // 獲取特定位置的寵物數據
            let pet = userPetsInfo[indexPath.row]
            
            // 使用 configure 方法設置單元格的內容
            cell.configure(with: pet,images: petsImages)
                    
            return cell
        } else {
            // 在這裡處理其他部分或情況
            // 根據需要提供默認 cell 或返回空 cell
            let cell = UITableViewCell() // 提供一個默認的 UITableViewCell
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 當用戶點擊單元格時，執行以下代碼
//        let taskPetInformationVC = TaskPetInformationVC() // 創建PetInformationEditVC實例
//
//        let selectedPet = userPetsInfo[indexPath.row]
//
//        taskPetInformationVC.selectedPet = selectedPet // 設置選定的寵物信息
        
        tableView.deselectRow(at: indexPath, animated: true) //取消選取
        
//        navigationController?.pushViewController(taskPetInformationVC, animated: true)
        
    }
    
    
}


