//
//  PersonalVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/31.
//

import UIKit

class PersonalVC: UIViewController, UITextFieldDelegate {
    
    var cities: [City] = []  // 解析後的資料陣列
    
    var cityMenuItems: [UIMenuElement] = []
    
    var componentIsSelect = false
    
    private let personScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true // 垂直滾動條
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = UIColor.systemBackground
        return scrollView
    }()
    
    private let paperView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "個人資訊"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    private let personalImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.circle.fill")
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "名稱"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let userNameFiled: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constraints.cornerRadious
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "性別"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let genderSelectButton: UISegmentedControl = {
        let button = UISegmentedControl()
        button.insertSegment(withTitle: "Male,男", at: 0, animated: false)
        button.insertSegment(withTitle: "Female,女", at: 1, animated: false)
        button.layer.cornerRadius = Constraints.cornerRadious
        return button
    }()
    
//    private let petTableCell: UITableViewCell = {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "petcell")
//        cell.imageView?.image = UIImage(systemName: "pawprint.fill")
//        cell.textLabel?.text = "編輯寵物資訊"
//        cell.selectionStyle = .default
//        cell.layer.borderWidth = 1.0 // 外框線寬度
//        cell.layer.borderColor = UIColor.black.cgColor // 外框線顏色
//        return cell
//    }()
    
    private let creatPetBtn: UIButton = {
        let button = UIButton()
        button.setTitle( "編輯寵物資訊", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.contentVerticalAlignment = .center
        return button
    }()
    
    private let livingArea: UILabel = {
        let label = UILabel()
        label.text = "居住區域"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let livingAreaMenuBtn: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.setTitleColor(.label, for: .normal)
        button.menu = UIMenu(children: [
            UIAction(title: "臺北市", handler: { action in
            print("臺北市")})
        ])
        return button
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "自我介紹"
        label.font = UIFont.systemFont(ofSize: 28)
        return label
    }()
    
    private let introductionTextView: UITextView = {
        let text = UITextView()
        text.textColor = .label
        text.text = "請輸入自我介紹"
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.label.cgColor
        text.addBottomBorder(borderColor: UIColor.systemGray.cgColor, borderWidth: text.width - 30)
        text.addCharCalculator(max: 300)
        return text
    }()
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addSubviewToScrollView()
        
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userNameFiled.delegate = self
        
        if let data = NSDataAsset(name: "taiwanDistricts")?.data {
            do {
                cities = try JSONDecoder().decode([City].self, from: data)
            } catch {
                print("JSON decoding error: \(error)")
            }
        }
        
        // 遍歷城市列表
        for city in cities {
            // 創建城市的子菜單
            var districtMenuItems: [UIMenuElement] = []
            
            // 遍歷城市的區域
            for district in city.districts {
                // 創建區域的UIAction並添加到區域子菜單
                let districtAction = UIAction(title: city.name + "-" + district.name, handler: { action in
                    print("\(city.name) - \(district.name)")
                })
                districtMenuItems.append(districtAction)
            }
            // 創建城市的UIMenu，將區域子菜單作為子項添加
            let cityMenu = UIMenu(title: city.name, children: districtMenuItems)
            cityMenuItems.append(cityMenu)
        }
        // 創建最終的UIMenu，將城市菜單作為子項添加
        let finalMenu = UIMenu(children: cityMenuItems)
        // 將最終的UIMenu設置為livingAreaMenuBtn的menu
        livingAreaMenuBtn.menu = finalMenu
        
        view.backgroundColor = .systemBackground
        
        guard let name = UserDataManager.shared.userData["Name"] as? String,
              let introduction = UserDataManager.shared.userData["Introduction"] as? String,
              let residenceArea = UserDataManager.shared.userData["ResidenceArea"] as? String,
              let gender = UserDataManager.shared.userData["Gender"] as? String else { return }
//        print(name, introduction, residenceArea, gender)
        userNameFiled.text = name
        introductionTextView.text = introduction
        livingAreaMenuBtn.setTitle(residenceArea, for: .normal)
        
        
        if gender == "Male,男" {
            genderSelectButton.selectedSegmentIndex = 0
        } else if gender == "Female,女" {
            genderSelectButton.selectedSegmentIndex = 1
        }
        
        
        creatPetBtn.addTarget(self, action: #selector(didTapCreatPetBtn), for: .touchUpInside)
        // 添加Image點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePressedToPicker))
        personalImage.addGestureRecognizer(tapGesture)
        
        // 創建一個 Save 按鈕
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        // 設置 Save 按鈕為右側的 bar button item
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    
    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        personScrollView.frame = view.bounds
        personScrollView.contentSize = CGSize(width: view.width, height: introductionTextView.bottom + 20) // 設置內容大小
        
        titleLabel.frame = CGRect(
            x: 0,
            y: 10,
            width: 162,
            height: 48)
        titleLabel.center.x = view.xCenter
        
        // 設定 personalImage 位置，在 titleLabel 下面靠左
        personalImage.frame = CGRect(
            x: 45,
            y: titleLabel.bottom + 30.0,
            width: 150,
            height: 150)
        personalImage.contentMode = .scaleAspectFill // 設置圖片內容模式
        personalImage.clipsToBounds = true // 裁剪圖片以適應圓形邊界
        personalImage.layer.cornerRadius = personalImage.frame.size.width / 2 // 設置圓角半徑為寬度的一半
        // 設定 userNameLabel 位置，在 personalImage 右邊，在 title 下方
        userNameLabel.frame = CGRect(
            x: 0,
            y: titleLabel.bottom + 10,
            width: 60,
            height: 40)
        userNameLabel.center.x = personalImage.right + (view.width - personalImage.right) / 2
        
        // 設定 userNameFiled 位置，在 userNameLabel 下面，中心點與 userNameLabel 對齊
        userNameFiled.frame = CGRect(
            x: 0,
            y: userNameLabel.bottom + 5,
            width: view.width - personalImage.right - 60,
            height: 40)
        userNameFiled.center.x = userNameLabel.center.x
        
        // 設定 genderLabel 位置，在 userNameFiled 下方，與 userNameLabel 左右對齊
        genderLabel.frame = CGRect(
            x: 0,
            y: userNameFiled.bottom + 10,
            width: 60,
            height: 40)
        genderLabel.center.x = userNameLabel.center.x
        
        // 設定 genderSelectButton 位置，在 genderLabel 下方，中心點與上方 genderLabel 中心點 x 一樣
        genderSelectButton.frame = CGRect(
            x: 0,
            y: genderLabel.bottom + 5,
            width: view.width - personalImage.right - 40,
            height: 40)
        genderSelectButton.center.x = genderLabel.center.x
        
        
        // 設定 petTableCell 位置，在 genderSelectButton 下方，水平置中
//        petTableCell.frame = CGRect(
//            x: view.xCenter - petTableCell.width / 2,
//            y: genderSelectButton.bottom + 20,
//            width: petTableCell.width,
//            height: petTableCell.height)
        
        // 設定 creatPetBtn 位置，在 petTableCell 下方，水平置中
        creatPetBtn.frame = CGRect(
            x: 0,
            y: genderSelectButton.bottom + 20,
            width: 200,
            height: 36)
        creatPetBtn.center.x = view.xCenter
        
        // 設定 livingArea 位置，在 creatPetBtn 下方，水平置中
        livingArea.frame = CGRect(
            x: 0,
            y: creatPetBtn.bottom + 10,
            width: 100,
            height: 36)
        livingArea.center.x = view.xCenter
        
        // 設定 livingAreaMenuBtn 位置，在 livingArea 下方，水平置中
        livingAreaMenuBtn.frame = CGRect(
            x: view.xCenter - 75,
            y: livingArea.bottom,
            width: 150,
            height: 50)
        
        // 設定 introductionLabel 位置，在 petTypeBtn 下方，水平置中
        introductionLabel.frame = CGRect(
            x: 0,
            y: livingAreaMenuBtn.bottom + 5,
            width: 130,
            height: 40)
        introductionLabel.center.x = view.xCenter
        
        // 設定 introductionTextView 位置，在 introductionLabel 下方，水平置中
        introductionTextView.frame = CGRect(
            x: 0,
            y: introductionLabel.bottom + 10,
            width: view.width - 100,
            height: 600)
        introductionTextView.center.x = view.xCenter
        
    }
    
    
    private func addSubviewToScrollView() {
        
        personScrollView.addSubview(titleLabel)
        personScrollView.addSubview(personalImage)
        personScrollView.addSubview(userNameLabel)
        personScrollView.addSubview(userNameFiled)
        personScrollView.addSubview(genderLabel)
        personScrollView.addSubview(genderSelectButton)
//        personScrollView.addSubview(petTableCell)
        personScrollView.addSubview(creatPetBtn)
        personScrollView.addSubview(livingArea)
        personScrollView.addSubview(livingAreaMenuBtn)
        personScrollView.addSubview(introductionLabel)
        personScrollView.addSubview(introductionTextView)
        view.addSubview(personScrollView)
    }
    
    @objc private func didTapCreatPetBtn() {
        // 創建 PetVC 實例
        let petVC = PetTabViewController()
        // 設置以全畫面顯示
        petVC.modalPresentationStyle = .fullScreen
        // 使用 navigationController 進行跳轉（如果您的 PersonalVC 嵌入在 UINavigationController 中）
        navigationController?.pushViewController(petVC, animated: true)
    }
    
    // Save 按鈕的動作
    @objc func saveButtonTapped() {
        // 在這裡處理 Save 按鈕被點擊的邏輯
        guard let username = userNameFiled.text, !username.isEmpty else {
            // 彈出警告
            let alert = UIAlertController(title: "錯誤", message: "名稱不能為空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        UserDataManager.shared.userData["Name"] = username
        UserDataManager.shared.userData["Introduction"] = introductionTextView.text
        UserDataManager.shared.userData["ResidenceArea"] = livingAreaMenuBtn.titleLabel?.text
        
        var gender = "private"
        switch genderSelectButton.selectedSegmentIndex {
        case 0:
            gender = "Male,男"
        case 1:
            gender = "Female,女"
        default:
            gender = "private"
        }
        UserDataManager.shared.userData["Gender"] = gender
        
        
        UserDataManager.shared.updateUserProfile{ error in
            // 處理更新完成後的邏輯
            if let error = error {
                // 處理錯誤情況
                print("更新用戶資料失敗：\(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "錯誤", message: "個人資料更新失敗", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                // 更新成功
                DispatchQueue.main.async {
                    print("個人資料更新成功")
                    let alert = UIAlertController(title: "成功", message: "個人資料更新成功", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func imagePressedToPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self // 設置代理為 PersonalVC
        imagePicker.sourceType = .photoLibrary // 或者 .camera，視需要選擇相冊或相機
        // 開啟圖像選擇器
        present(imagePicker, animated: true, completion: nil)
    }

    
    
}


extension PersonalVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 當用戶選擇了圖像後調用的方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // 在這裡處理選擇的圖像，例如顯示在 personalImage 上
            personalImage.image = selectedImage
        }
        
        // 關閉圖像選擇器
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 當用戶取消選擇圖像時調用的方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 關閉圖像選擇器
        picker.dismiss(animated: true, completion: nil)
    }
}
