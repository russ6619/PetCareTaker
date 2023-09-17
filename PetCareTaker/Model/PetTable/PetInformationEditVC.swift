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
    
    var petTypes: PetTypes?
    var petimage: PetImage = PetImage() // 實例化 PetImage
    var selectedOptions: [String] = []

    
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
        
    }
    
    @objc func handleTap() {
        // 在這裡觸發解除 firstResponder，關閉鍵盤
        view.endEditing(true)
    }
    
    // 創建 PetPersonalityTableVC 實例時設置代理
    func showPersonalityOptions() {
        let personalityOptionsVC = petPersonalityTableVC()
        personalityOptionsVC.delegate = self
        personalityOptionsVC.selectedOptions = selectedOptions // 傳遞 selectedOptions 給 petPersonalityTableVC
        navigationController?.pushViewController(personalityOptionsVC, animated: true)
    }
    
    // 實現 PetPersonalitySelectionDelegate 協議的方法，用於接收選擇的項目
    func didSelectPersonalityOptions(_ selectedOptions: [String]) {
        // 在這裡處理選擇的項目，您可以將它們存儲到 selectedOptions 或進行其他操作
        self.selectedOptions = selectedOptions // 更新 selectedOptions
        print("選擇的項目：\(selectedOptions)")
    }

    func updatePetPersonality(with selectedOptions: [String]) {
        // 在這裡處理選擇的個性項目，您可以將它們存儲到 petInfo 或進行其他操作
        print("選擇的個性項目：\(selectedOptions)")
        
        // 更新相關的數據，例如 petInfo.personality
        
        // 重新載入表格視圖的相關部分，這將刷新您的表格視圖以顯示更新後的內容
        tableView.reloadData()
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
        //        print("Section: \(indexPath.section), row: \(indexPath.row)")
        if indexPath.section == 4 && indexPath.row == 2 {
            // 點擊了 "個性(複選)" 選項
            let petPersonalityTableVC = petPersonalityTableVC() // 創建 "petPersonalityTableVC" 實例
            navigationController?.pushViewController(petPersonalityTableVC, animated: true) // 使用導航控制器進行跳轉，帶有左至右的動畫
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
                cell.buttonMenu.setTitle(selectedPet.type, for: .normal)
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
                cell.buttonMenu.setTitle(selectedPet.size, for: .normal)
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
                cell.buttonMenu.setTitle(selectedPet.gender, for: .normal)
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
                
                if selectedPet.neutered == "0" {
                    cell.buttonMenu.setTitle("未結紮", for: .normal)
                } else {
                    cell.buttonMenu.setTitle("已結紮", for: .normal)
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
                if selectedPet.neutered == "0" {
                    cell.buttonMenu.setTitle("沒有規律施打疫苗", for: .normal)
                } else {
                    cell.buttonMenu.setTitle("有規律施打疫苗", for: .normal)
                }
                return cell
            case 2: // 寵物個性
                let cell = UITableViewCell()
                cell.textLabel?.text = "個性(複選)" // 設置標題
                print("\(selectedOptions)")
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .disclosureIndicator

                // 自定義的 UILabel，顯示在右側
                let customLabel = UILabel()
                if selectedPet.personality.isEmpty {
                    customLabel.text = "請選擇寵物個性"
                } else {
                    customLabel.text = selectedPet.personality
                }
                
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
