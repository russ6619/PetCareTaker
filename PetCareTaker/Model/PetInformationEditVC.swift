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

class PetInformationEditVC: UIViewController {
    
    var petTypes: PetTypes?
    var petimage: PetImage = PetImage() // 實例化 PetImage
    
    var petInfo: PetInfo = PetInfo()
    // 定義selectedPet屬性以保存選定的寵物數據
    var selectedPet: Pet?
    
    // 在此處定義您的表單項目
    let sectionTitles: [String] = ["","寵物名稱", "寵物介紹", "基本資料", "詳細資料"]
    let formItems: [[String]] = [
        ["大頭照","選擇大頭照"],
        ["寵物名稱"],
        ["寵物介紹"],
        ["種類", "尺寸", "出生日期", "性別"],
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置 UIViewController 的 view
        view.backgroundColor = .white
        
        // 設置 UITableView 的代理和數據源
        tableView.dataSource = self
        tableView.delegate = self
        
        // 註冊自定義的 UITableViewCell 類別
        tableView.register(PetInfoTableViewCell.self, forCellReuseIdentifier: "PetInfoCell")
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:  // 照片
            if indexPath.row == 0 {
                // petImageViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "petImageViewCell", for: indexPath) as! petImageViewCell
                // 配置 petImageViewCell 的相關操作
                cell.petImage.image = petimage.image
                
                return cell
            } else if indexPath.row == 1 {
                // ImageSelectionCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSelectionCell", for: indexPath) as! ImageSelectionCell
                // 配置 ImageSelectionCell 的相關操作
                cell.delegate = self
                return cell
            }
        case 1:     // 寵物名稱
            // PetInfoTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PetInfoCell", for: indexPath) as! PetInfoTableViewCell
            // 配置 PetInfoTableViewCell 的相關操作
            return cell
        case 2:     // 寵物狀況描述
            // TextViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            // 配置 TextViewCell 的相關操作
            return cell
        case 3:     // 基本資料
            // ButtonMenuCell，具體根據 row 的不同配置不同的內容
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonMenuCell", for: indexPath) as! ButtonMenuCell
            if indexPath.row == 0 {
                // 種類
                if let data = NSDataAsset(name: "petType")?.data {
                    do {
                        let petTypes = try JSONDecoder().decode(PetTypes.self, from: data)
                        // 將 JSON 數據轉換為相應的結構（例如，PetTypes）
                        // 其中 PetTypes 是你自定義的結構，用於表示 JSON 數據的結構
                        var petTypeMenuItems: [UIMenuElement] = []

                        for (petCategory, petBreeds) in petTypes.petType {
                            var breedMenuItems: [UIMenuElement] = []

                            for breed in petBreeds {
                                let breedAction = UIAction(title: breed, handler: { action in
                                    print("\(petCategory) - \(breed)")
                                    // 在這裡處理所選寵物種類和品種的操作
                                })
                                breedMenuItems.append(breedAction)
                            }
                            let categoryMenu = UIMenu(title: petCategory, children: breedMenuItems)
                            petTypeMenuItems.append(categoryMenu)
                        }
                        let petTypeMenu = UIMenu(children: petTypeMenuItems)
                        // 將 petTypeMenu 設置為相關的按鈕或視圖的 menu
                        cell.buttonMenu.menu = petTypeMenu
                    } catch {
                        print("JSON decoding error: \(error)")
                    }
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
            } else if indexPath.row == 2 {
                // 年份選擇
                let currentYear = Calendar.current.component(.year, from: Date())
                let yearsRange = (currentYear - 100)...currentYear
                var yearMenuItems: [UIMenuElement] = []

                for year in yearsRange.reversed() {
                    let yearAction = UIAction(title: "\(year)", handler: { action in
                        print("選擇了年份 \(year)")
                        // 在這裡處理所選年份的操作
                    })
                    yearMenuItems.append(yearAction)
                }
                let yearMenu = UIMenu(title: "出生年份", children: yearMenuItems)
                cell.buttonMenu.menu = yearMenu
            } else if indexPath.row == 3 {
                // 月份選擇
                let monthMenuItems: [UIMenuElement] = (1...12).map { month in
                    UIAction(title: "\(month)月", handler: { action in
                        print("選擇了月份 \(month)月")
                        // 在這裡處理所選月份的操作
                    })
                }
                let monthMenu = UIMenu(title: "出生月份", children: monthMenuItems)
                cell.buttonMenu.menu = monthMenu
            } else if indexPath.row == 4 {
                // 性別選擇
                let genderMenuItems: [UIMenuElement] = [
                    UIAction(title: "Male,男", handler: { action in
                        print("選擇了性別 Male,男")
                        // 在這裡處理所選性別的操作
                    }),
                    UIAction(title: "Female,女", handler: { action in
                        print("選擇了性別 Female,女")
                        // 在這裡處理所選性別的操作
                    })
                ]
                let genderMenu = UIMenu(title: "性別", children: genderMenuItems)
                cell.buttonMenu.menu = genderMenu
            }

            return cell

        case 4:     // 詳細資料
            // ButtonMenuCell，具體根據 row 的不同配置不同的內容
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonMenuCell", for: indexPath) as! ButtonMenuCell
            // 根據 row 配置 ButtonMenuCell 的相關操作
            return cell
        default:
            // 其他情況的處理
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            // petImageViewCell 的計算高度
            let imageSize = petimage.image?.size ?? CGSize(width: 10, height: 10) // 如果没有圖，使用默認大小
            let imageAspectRatio = imageSize.width / imageSize.height
            let cellWidth = tableView.bounds.width
            let cellHeight = imageSize.height
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
        // 將選擇的圖像設置給 petInfo 或 petImageViewCell 中的 petImage
        petimage.image = image

        // 找到 petImageViewCell 的 indexPath
        if let indexPath = tableView.indexPath(for: petImageViewCell()) { // 使用 petImageViewCell() 的實例
            // 刷新該行
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.beginUpdates()
            tableView.endUpdates()

        }
        
        tableView.reloadData()
    }
}

extension PetInformationEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.frame = CGRect(origin: textView.frame.origin,
                                size: CGSize(width: textView.width,
                                             height: textView.intrinsicContentSize.height))
    }
}


enum PetInfoSection: Int, CaseIterable {
    case image
    case name
    case description
    case basicInfo
    case detailedInfo
    
    var title: String {
        switch self {
        case .image:
            return ""
        case .name:
            return "寵物名稱"
        case .description:
            return "寵物介紹"
        case .basicInfo:
            return "基本資料"
        case .detailedInfo:
            return "詳細資料"
        }
    }
}

struct PetInfo {
    var name: String = ""
    var description: String = ""
    var type: String = ""
    var size: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var neutered: Bool = false
    var vaccinated: Bool = false
    var personality: String = ""
}

struct PetImage {
    var image: UIImage?
}
