//
//  PetInformationEditVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/11.
//

import UIKit

protocol ImageSelectionCellDelegate: AnyObject {
    func presentImagePicker(_ imagePicker: UIImagePickerController)
    func updatePetImage(_ image: UIImage)
}

class PetInformationEditVC: UIViewController, PetPersonalitySelectionDelegate {
    
    var editingCell: ButtonMenuCell?
    let userID: String = UserDataManager.shared.userData["UserID"] as! String
    
    var petTypes: PetTypes?
    var petimage: PetImage = PetImage() // 實例化 PetImage
    var didSelectedOptions: [String] = []
    
    
    var petInfo: PetInfo = PetInfo()
    // 定義selectedPet屬性以保存選定的寵物數據
    var selectedPet: Pet!
    
    // 在此處定義您的表單項目
    let sectionTitles: [String] = ["","寵物名稱", "寵物介紹", "基本資料", "詳細資料"]
    let formItems: [[String]] = [
        ["大頭照","選擇大頭照"],
        ["寵物名稱"],
        ["寵物介紹"],
        ["種類", "尺寸", "出生年份","出生月份", "性別"],
        ["是否結紮", "是否規律施打疫苗", "個性"]
    ]
    
    // 創建 UITableView
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    func configureImageSelectionCell(_ cell: ImageSelectionCell) {
        cell.delegate = self
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設置 UIViewController 的 view
        view.backgroundColor = .white
        
        // 設置 UITableView 的代理和數據源
        tableView.dataSource = self
        tableView.delegate = self
        
        // 註冊自定義的 UITableViewCell 類別
        tableView.register(PetNameTableViewCell.self, forCellReuseIdentifier: "PetInfoCell")
        tableView.register(ImageSelectionCell.self, forCellReuseIdentifier: "ImageSelectionCell")
        tableView.register(petImageViewCell.self, forCellReuseIdentifier: "petImageViewCell")
        tableView.register(TextViewCell.self, forCellReuseIdentifier: "TextViewCell")
        tableView.register(ButtonMenuCell.self, forCellReuseIdentifier: "ButtonMenuCell")
        
        // 添加 UITableView 作為子視圖
        view.addSubview(tableView)
        
        // 設置 UITableView 的約束，根據您的界面設計來調整
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        // 創建一個輕觸手勢辨識器，用於關閉鍵盤
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false // 允許觸摸事件傳遞到子視圖
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        // 創建一個 Save 按鈕
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        // 設置 Save 按鈕為右側的 bar button item
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func handleTap() {
        // 在這裡觸發解除 firstResponder，關閉鍵盤
        view.endEditing(true)
    }
    
    // MARK: SAVE BTN
    @objc func saveButtonTapped() {
        // 獲取寵物名稱
        if let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PetNameTableViewCell {
            if let petName = nameCell.textField.text {
                selectedPet.name = petName
            }
        }
        
        // 獲取寵物介紹
        if let descriptionCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? TextViewCell {
            if let petDescription = descriptionCell.textView.text {
                selectedPet.precautions = petDescription
            }
        }
        
        // 獲取寵物種類
        if let typeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ButtonMenuCell {
            if let petType = typeCell.buttonMenu.title(for: .normal) {
                selectedPet.type = petType
            }
        }
        
        // 獲取寵物尺寸
        if let sizeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as? ButtonMenuCell {
            if let petSize = sizeCell.buttonMenu.title(for: .normal) {
                selectedPet.size = petSize
            }
        }
        
        // 獲取出生年份
        if let birthYearCell = tableView.cellForRow(at: IndexPath(row: 2, section: 3)) as? ButtonMenuCell {
            if let birthYear = birthYearCell.buttonMenu.title(for: .normal) {
                // 獲取出生月份
                if let birthMonthCell = tableView.cellForRow(at: IndexPath(row: 3, section: 3)) as? ButtonMenuCell {
                    if let birthMonth = birthMonthCell.buttonMenu.title(for: .normal), !birthMonth.isEmpty {
                        // 如果出生月份不為空，則將出生年份和出生月份組合在一起
                        selectedPet.birthDate = birthYear + "-" + birthMonth
                    } else {
                        // 如果出生月份為空，則只存儲出生年份
                        selectedPet.birthDate = birthYear
                    }
                }
            }
        }
        
        
        // 獲取性別
        if let genderCell = tableView.cellForRow(at: IndexPath(row: 4, section: 3)) as? ButtonMenuCell {
            if let gender = genderCell.buttonMenu.title(for: .normal) {
                selectedPet.gender = gender
            }
        }
        
        // 獲取是否結紮
        if let neuteredCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ButtonMenuCell {
            if let neutered = neuteredCell.buttonMenu.title(for: .normal) {
                selectedPet.neutered = neutered
            }
        }
        
        // 獲取是否規律施打疫苗
        if let vaccinatedCell = tableView.cellForRow(at: IndexPath(row: 1, section: 4)) as? ButtonMenuCell {
            if let vaccinated = vaccinatedCell.buttonMenu.title(for: .normal) {
                selectedPet.vaccinated = vaccinated
            }
        }
        
        // 判斷 selectedPet.petID 是否為空
        if selectedPet.petID.isEmpty {
            // 將 selectedPet 轉換為 JSON
            // 創建一個包含 userID 和 selectedPet 的實例
            let petData = PetAndUserData(
                userID: userID,
                petID: selectedPet.petID, 
                name: selectedPet.name,
                gender: selectedPet.gender,
                type: selectedPet.type,
                birthDate: selectedPet.birthDate,
                size: selectedPet.size,
                neutered: selectedPet.neutered,
                vaccinated: selectedPet.vaccinated,
                personality: selectedPet.personality,
                photo: selectedPet.photo,
                precautions: selectedPet.precautions
            )

            print(petData)
            // 使用 JSONEncoder 將結構轉換為 JSON 數據
            if let jsonData = try? JSONEncoder().encode(petData) {
                // 創建 URLRequest
                guard let createPetUrl = URL(string: ServerApiHelper.shared.createPetUrl) else {
                    return
                }
                var request = URLRequest(url: createPetUrl)
                request.httpMethod = "POST"
                
                // 設定 HTTP 請求的主體數據
                request.httpBody = jsonData
                
                // 設定 HTTP 請求的標頭
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // 創建 URLSession 並發送請求
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    // 處理伺服器回應，檢查是否成功建立寵物資料
                    if let error = error {
                        // 處理錯誤情況
                        print("建立寵物資料失敗：\(error)")
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "錯誤", message: "建立寵物資料失敗", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "確定", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else if let data = data {
                        // 處理成功建立寵物資料的情況
                        // 解析伺服器回傳的 JSON 數據，如果有需要的話
                        do {
                            // 在這裡解析伺服器回傳的 JSON 數據
                            // 可以更新本地寵物資料的 petID
                            let createdPet = try JSONDecoder().decode(Pet.self, from: data)
                            print("建立寵物資料成功")
                        } catch {
                            print("解析伺服器回傳的 JSON 失敗：\(error)")
                        }
                        
                        // 更新成功後的處理
                        DispatchQueue.main.async {
                            print("寵物資料建立成功")
                            UserDataManager.shared.fetchUserPetData(userID: self.userID) { error in
                                if let error = error {
                                    // 處理錯誤情況，例如顯示錯誤訊息
                                    print("無法獲取用戶寵物資料，錯誤：\(error.localizedDescription)")
                                } else {
                                    // 寵物資料下載成功，可以在這裡處理用戶寵物資料，例如設定 userPetData
                                    print("重新下載寵物資料成功：\(UserDataManager.shared.petsData)")
                                }
                            }
                            let alert = UIAlertController(title: "成功", message: "寵物資料建立成功", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "確定", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                task.resume()
            }
        } else {
            UserDataManager.shared.updatePetData(userID: userID, selectedPet: selectedPet, completion: { error in
                // 處理更新完成後的邏輯
                if let error = error {
                    // 處理錯誤情況
                    print("更新寵物資料失敗：\(error)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "錯誤", message: "寵物資料更新失敗", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "確定", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    // 更新成功
                    DispatchQueue.main.async {
                        print("寵物資料更新成功")
                        let alert = UIAlertController(title: "成功", message: "寵物資料更新成功", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "確定", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    // 創建 PetPersonalityTableVC 實例時設置代理
    func showPersonalityOptions() {
        // 初始化 selectedOptions，可以是空的或其他適當的初始值
        didSelectedOptions = [] // 這裡示範初始化為空的
        
        // 將 selectedPet.personality 以逗號和空格分割成陣列，並去除前後的空格
        let personalityItems = selectedPet.personality.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        
        // 添加到 selectedOptions 中
        didSelectedOptions.append(contentsOf: personalityItems)
        
        let personalityOptionsVC = petPersonalityTableVC()
        personalityOptionsVC.delegate = self
        personalityOptionsVC.selectedOptions = didSelectedOptions
        navigationController?.pushViewController(personalityOptionsVC, animated: true)
    }
    
    
    
    
    // 實現 PetPersonalitySelectionDelegate 協議的方法，用於接收選擇的項目
    func didSelectPersonalityOptions(_ selectedOptions: [String]) {
        // 在這裡處理選擇的項目，您可以將它們存儲到 didSelectedOptions 或進行其他操作
        selectedPet.personality = selectedOptions.joined(separator: ",")
        
        tableView.reloadRows(at: [IndexPath(row: 2, section: 4)], with: .automatic)
    }
    
    func updatePetPersonality(with selectedOptions: [String]) {
        
        // 重新載入表格視圖的相關部分，這將刷新您的表格視圖以顯示更新後的內容
        tableView.reloadRows(at: [IndexPath(row: 2, section: 4)], with: .automatic)
    }
    
    
}

// MARK: UITableView
extension PetInformationEditVC: UITableViewDelegate, UITableViewDataSource {
    
    // 實現 UITableViewDataSource 的相關方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formItems[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 && indexPath.row == 2 {
            showPersonalityOptions()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:  // 照片
            if indexPath.row == 0 {
                // petImageViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "petImageViewCell", for: indexPath) as! petImageViewCell
                cell.petImage.image = petimage.image
                
                return cell
            } else if indexPath.row == 1 {
                // ImageSelectionCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSelectionCell", for: indexPath) as! ImageSelectionCell
                cell.delegate = self
                return cell
            }
        case 1:     // 寵物名稱
            // PetNameTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetInfoCell", for: indexPath) as! PetNameTableViewCell
            cell.textField.text = selectedPet.name
            cell.textField.delegate = self
            return cell
        case 2:     // 寵物狀況描述
            // TextViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            cell.textView.placeholder = "請輸入您的寵物狀況或是注意事項"
            cell.textView.text = selectedPet.precautions
            cell.textView.placeholderColor = .gray
            cell.textView.delegate = self
            cell.textViewHeightConstraint?.isActive = true
            return cell
        case 3:     // 基本資料
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonMenuCell", for: indexPath) as! ButtonMenuCell
            if indexPath.row == 0 {
                // 種類
                var petTypeMenuItems: [UIMenuElement] = []
                
                let allowedPetCategories = ["貓", "狗", "鳥", "兔", "鼠"]
                
                for petCategory in allowedPetCategories {
                    let breedAction = UIAction(title: petCategory, handler: { action in
                        // 在這裡處理所選寵物種類的操作
                        self.selectedPet.type = petCategory
                    })
                    breedAction.state = .off
                    petTypeMenuItems.append(breedAction)
                }
                let petTypeMenu = UIMenu(title: "種類", options: .singleSelection, children: petTypeMenuItems)
                cell.buttonMenu.menu = petTypeMenu
                if !selectedPet.type.isEmpty {
                    cell.buttonMenu.setTitle(selectedPet.type, for: .normal)
                }
            } else if indexPath.row == 1 {
                // 尺寸
                let sizeMenuItems: [UIMenuElement] = [
                    UIAction(title: "迷你(小於5公斤)", handler: { action in
                        print("迷你(小於5公斤)")
                        // 在這裡處理所選尺寸的操作
                    }),
                    UIAction(title: "小型(5-10公斤)", handler: { action in
                        print("小型(5-10公斤)")
                        // 在這裡處理所選尺寸的操作
                    }),
                    UIAction(title: "中型(10-20公斤)", handler: { action in
                        print("中型(10-20公斤)")
                        // 在這裡處理所選尺寸的操作
                    }),
                    UIAction(title: "大型(20-40公斤)", handler: { action in
                        print("大型(20-40公斤)")
                        // 在這裡處理所選尺寸的操作
                    }),
                    UIAction(title: "超大型(大於40公斤)", handler: { action in
                        print("超大型(大於40公斤)")
                        // 在這裡處理所選尺寸的操作
                    })
                ]
                let sizeMenu = UIMenu(title: "尺寸", children: sizeMenuItems)
                cell.buttonMenu.menu = sizeMenu
                if !selectedPet.size.isEmpty {
                    cell.buttonMenu.setTitle(selectedPet.size, for: .normal)
                    
                }
            } else if indexPath.row == 2 {
                // 年份選擇
                let currentYear = Calendar.current.component(.year, from: Date())
                let yearsRange = (currentYear - 100)...currentYear
                var yearMenuItems: [UIMenuElement] = []
                
                for year in yearsRange.reversed() {
                    let yearAction = UIAction(title: "\(year)", handler: { action in
                        print("\(year)")
                        // 在這裡處理所選年份的操作
                    })
                    yearMenuItems.append(yearAction)
                }
                let yearMenu = UIMenu(title: "出生年份", children: yearMenuItems)
                cell.buttonMenu.menu = yearMenu
                // 解析 selectedPet.birthDate，假設它的格式是"yyyy-MM"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM"
                if let birthDate = dateFormatter.date(from: selectedPet.birthDate) {
                    let birthYear = Calendar.current.component(.year, from: birthDate)
                    cell.buttonMenu.setTitle("\(birthYear)", for: .normal)
                }
            } else if indexPath.row == 3 {
                // 月份選擇
                let monthMenuItems: [UIMenuElement] = (1...12).map { month in
                    UIAction(title: "\(month)月", handler: { action in
                        print("\(month)月")
                        // 在這裡處理所選月份的操作
                    })
                }
                let monthMenu = UIMenu(title: "出生月份", children: monthMenuItems)
                cell.buttonMenu.menu = monthMenu
                // 解析 selectedPet.birthDate，假設它的格式是"yyyy-MM"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM"
                if let birthDate = dateFormatter.date(from: selectedPet.birthDate) {
                    let birthYear = Calendar.current.component(.month, from: birthDate)
                    cell.buttonMenu.setTitle("\(birthYear)", for: .normal)
                }
            } else if indexPath.row == 4 {
                // 性別選擇
                let genderMenuItems: [UIMenuElement] = [
                    UIAction(title: "Male,公", handler: { action in
                        print("Male,公")
                        // 在這裡處理所選性別的操作
                    }),
                    UIAction(title: "Female,母", handler: { action in
                        print("Female,母")
                        // 在這裡處理所選性別的操作
                    })
                ]
                let genderMenu = UIMenu(title: "性別", children: genderMenuItems)
                cell.buttonMenu.menu = genderMenu
                if !selectedPet.gender.isEmpty {
                    cell.buttonMenu.setTitle(selectedPet.gender, for: .normal)
                    
                }
            }
            
            return cell
            
        case 4:     // 詳細資料
            // 根據行數設置不同的選項
            var menuItems: [UIMenuElement] = []
            switch indexPath.row {
            case 0:
                // 選項「是否結紮」
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonMenuCell", for: indexPath) as! ButtonMenuCell
                let neuteredMenuItems: [UIMenuElement] = [
                    UIAction(title: "已結紮", handler: { action in
                        print("已結紮")
                        // 在這裡處理已結紮的操作
                    }),
                    UIAction(title: "未結紮", handler: { action in
                        print("未結紮")
                        // 在這裡處理未結紮的操作
                    })
                ]
                menuItems = neuteredMenuItems
                let menu = UIMenu(title: "", children: menuItems)
                cell.buttonMenu.menu = menu
                if !selectedPet.neutered.isEmpty {
                    cell.buttonMenu.setTitle(selectedPet.neutered, for: .normal)
                    
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonMenuCell", for: indexPath) as! ButtonMenuCell
                // 選項「是否規律施打疫苗」
                let vaccinatedMenuItems: [UIMenuElement] = [
                    UIAction(title: "有規律施打疫苗", handler: { action in
                        print("有規律施打疫苗")
                        // 在這裡處理有規律施打疫苗的操作
                    }),
                    UIAction(title: "沒有規律施打疫苗", handler: { action in
                        print("沒有規律施打疫苗")
                        // 在這裡處理沒有規律施打疫苗的操作
                    })
                ]
                menuItems = vaccinatedMenuItems
                let menu = UIMenu(title: "", children: menuItems)
                cell.buttonMenu.menu = menu
                if !selectedPet.vaccinated.isEmpty {
                    cell.buttonMenu.setTitle(selectedPet.vaccinated, for: .normal)
                }
                return cell
            case 2: // 寵物個性
                let cell = UITableViewCell()
                cell.textLabel?.text = "個性(複選)" // 設置標題
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .disclosureIndicator
                
                // 自定義的 UILabel，顯示在右側
                let customLabel = UILabel()
                if selectedPet.personality.isEmpty {
                    customLabel.text = "請選擇寵物個性"
                } else {
                    customLabel.text = selectedPet.personality
                }
                customLabel.textAlignment = .right
                customLabel.textColor = UIColor.gray // 設置文本顏色
                customLabel.numberOfLines = 0
                customLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(customLabel)
                
                // 使用約束將 customLabel 放在 cell 的右側
                NSLayoutConstraint.activate([
                    customLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
                    customLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 150),
                    customLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    customLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                ])
                
                return cell
            default:
                break
            }
            
        default:
            // 其他情況的處理
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            // petImageViewCell 的計算高度
            let imageSize = petimage.image?.size ?? CGSize(width: 0, height: 0) // 如果沒有圖，使用默認大小
            let cellHeight: CGFloat
            if imageSize.height != 0 {
                cellHeight = imageSize.height + 100
            } else {
                cellHeight = 0
            }
            return cellHeight
        }
        
        return UITableView.automaticDimension
    }
    
}

// MARK: UITextField
extension PetInformationEditVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            // 寵物名稱的文本框
            if let text = textField.text, let range = Range(range, in: text) {
                petInfo.name = text.replacingCharacters(in: range, with: string)
            }
        } else if textField.tag == 1 {
            // 寵物介紹的文本框
            if let text = textField.text, let range = Range(range, in: text) {
                petInfo.description = text.replacingCharacters(in: range, with: string)
            }
        }
        return true
    }
    
    
}


// MARK: ImageSelection
extension PetInformationEditVC: ImageSelectionCellDelegate {
    func presentImagePicker(_ imagePicker: UIImagePickerController) {
        // 在這裡以模態方式顯示UIImagePicker
        present(imagePicker, animated: true, completion: nil)
    }
    
    func updatePetImage(_ image: UIImage) {
        // 壓縮圖片大小
        let compressedImage = compressImage(image, targetSize: CGSize(width: 150, height: 150)) // 設定目標大小
        
        // 將圖片切割成圓形
        let circularImage = makeCircularImage(compressedImage)
        
        // 將處理後的圖片設置給 petInfo 或 petImageViewCell 中的 petImage
        petimage.image = circularImage
        
        // 找到 petImageViewCell 的 indexPath
        if let indexPath = tableView.indexPath(for: petImageViewCell()) {
            // 刷新該行
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        tableView.reloadData()
    }
    
    // 壓縮圖片大小
    func compressImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(targetSize)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compressedImage ?? image
    }
    
    // 將圖片切割成圓形
    func makeCircularImage(_ image: UIImage) -> UIImage {
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = min(image.size.width, image.size.height) / 2
        imageView.layer.masksToBounds = true
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circularImage ?? image
    }
    
}

// MARK: UITextViewDelegate
extension PetInformationEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 計算 textView 的內容高度
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // 更新 textViewHeightConstraint 的 constant 屬性
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? TextViewCell {
            cell.textViewHeightConstraint?.constant = newSize.height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

extension PetInformationEditVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 如果點擊的是一個可編輯的文本視圖，則不處理手勢，讓文本視圖可以繼續編輯
        if let touchedView = touch.view, touchedView is UITextView {
            return false
        }
        return true
    }
}

struct PetImage {
    var image: UIImage?
}
