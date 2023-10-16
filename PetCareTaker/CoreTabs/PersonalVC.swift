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
    
    var serverImagePath: String?
    
    private let personScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true // 垂直滾動條
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = UIColor.systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "個人資訊"
//        label.textColor = .label
//        label.font = UIFont.systemFont(ofSize: 40)
//        label.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
//        label.layer.shadowOpacity = 0.2 // 陰影不透明度
//        label.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
//        label.layer.shadowRadius = 5 // 陰影半徑
//        return label
//    }()
    
    private let personalImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.circle.fill")
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill // 設置圖片視圖的內容模式
        image.layer.cornerRadius = 100
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "名稱"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .left
        label.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        label.layer.shadowOpacity = 0.2 // 陰影不透明度
        label.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        label.layer.shadowRadius = 5 // 陰影半徑
        label.translatesAutoresizingMaskIntoConstraints = false
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
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "性別"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .left
        label.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        label.layer.shadowOpacity = 0.2 // 陰影不透明度
        label.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        label.layer.shadowRadius = 5 // 陰影半徑
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderSelectButton: UISegmentedControl = {
        let button = UISegmentedControl()
        button.insertSegment(withTitle: "Male,男", at: 0, animated: false)
        button.insertSegment(withTitle: "Female,女", at: 1, animated: false)
        button.layer.cornerRadius = Constraints.cornerRadious
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let livingArea: UILabel = {
        let label = UILabel()
        label.text = "居住區域"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .left
        label.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        label.layer.shadowOpacity = 0.2 // 陰影不透明度
        label.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        label.layer.shadowRadius = 5 // 陰影半徑
        label.translatesAutoresizingMaskIntoConstraints = false
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
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constraints.cornerRadious
        button.backgroundColor = .secondarySystemBackground
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "自我介紹"
        label.font = UIFont.systemFont(ofSize: 28)
        label.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        label.layer.shadowOpacity = 0.2 // 陰影不透明度
        label.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        label.layer.shadowRadius = 5 // 陰影半徑
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let introductionTextView: UITextView = {
        let text = UITextView()
        text.textColor = .label
        text.text = "請輸入自我介紹"
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.masksToBounds = true
        text.layer.cornerRadius = Constraints.cornerRadious
        text.backgroundColor = .secondarySystemBackground
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.secondaryLabel.cgColor
        text.addBottomBorder(borderColor: UIColor.systemGray.cgColor, borderWidth: text.width - 30)
        text.addCharCalculator(max: 300)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    private var introductionTextViewHeightConstraint: NSLayoutConstraint!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let boldFont = UIFont.boldSystemFont(ofSize: 18)
        
        self.navigationController?.navigationBar.topItem?.title = "個人資訊"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: boldFont]
        
        userNameFiled.delegate = self
        // 啟用 UITextView 的自動調整高度功能
        introductionTextView.isScrollEnabled = false
        introductionTextView.delegate = self
        self.introductionTextViewHeightConstraint = introductionTextView.heightAnchor.constraint(equalToConstant: 100)

        addSubviewToScrollView()

        NSLayoutConstraint.activate([
        //設定personScrollView
            personScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            personScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            personScrollView.heightAnchor.constraint(equalToConstant: introductionTextView.bottom + 100),
            
        // 設定 personalImage 位置，在 title 下面置中
            personalImage.heightAnchor.constraint(equalToConstant: 200),
            personalImage.widthAnchor.constraint(equalToConstant: 200),
            personalImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        // 設定 userNameLabel 位置，在 personalImage 下面，左半邊
            userNameLabel.topAnchor.constraint(equalTo: personalImage.bottomAnchor, constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            userNameLabel.widthAnchor.constraint(equalToConstant: 60),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 userNameFiled 位置，在 userNameLabel 右邊，與 userNameLabel 等高
            userNameFiled.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            userNameFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameFiled.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            userNameFiled.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 genderLabel 位置，在 userNameLabel 下方，與 userNameLabel 左右對齊
            genderLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            genderLabel.widthAnchor.constraint(equalToConstant: 60),
            genderLabel.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 genderSelectButton 位置，在 genderLabel 右邊，與 genderLabel 等高
            genderSelectButton.topAnchor.constraint(equalTo: genderLabel.topAnchor),
            genderSelectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            genderSelectButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            genderSelectButton.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 livingArea 位置，在 genderLabel 下方，與genderLabel一齊靠左
            livingArea.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            livingArea.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            livingArea.widthAnchor.constraint(equalToConstant: 100),
            livingArea.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 livingAreaMenuBtn 位置，在 livingArea 下方，與genderSelectButton一齊靠左
            livingAreaMenuBtn.topAnchor.constraint(equalTo: livingArea.topAnchor),
            livingAreaMenuBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            livingAreaMenuBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            livingAreaMenuBtn.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 introductionLabel 位置，在 livingArea 下方，靠左
            introductionLabel.topAnchor.constraint(equalTo: livingArea.bottomAnchor, constant: 20),
            introductionLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
//            livingArea.widthAnchor.constraint(equalToConstant: 60),
//            livingArea.heightAnchor.constraint(equalToConstant: 40),
        
        // 設定 introductionTextView 位置，在 introductionLabel 下方
            introductionTextView.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 10),
            introductionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introductionTextViewHeightConstraint // 這是之前創建的高度約束
        ])
        
        
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
        personalImage.image = UserDataManager.shared.userImage
        
        
        
        if gender == "Male,男" {
            genderSelectButton.selectedSegmentIndex = 0
        } else if gender == "Female,女" {
            genderSelectButton.selectedSegmentIndex = 1
        }
        
        
//        creatPetBtn.addTarget(self, action: #selector(didTapCreatPetBtn), for: .touchUpInside)
        
        // 添加Image點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePressedToPicker))
        personalImage.addGestureRecognizer(tapGesture)
        
        // 創建一個 Save 按鈕
        let saveButton = UIBarButtonItem(title: "存檔", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        // 設置 Save 按鈕為右側的 bar button item
        self.navigationItem.rightBarButtonItem = saveButton
        
        
        let creatPetBtn = UIBarButtonItem(title: "寵物資訊", style: .plain, target: self, action: #selector(didTapCreatPetBtn))
        self.navigationItem.leftBarButtonItem = creatPetBtn
        
        
    }
    
    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        personScrollView.frame = view.bounds
//        personScrollView.contentSize = CGSize(width: view.width, height: introductionTextView.bottom + 100)
    }
    
    
    private func addSubviewToScrollView() {
        view.addSubview(personScrollView)
//        personScrollView.addSubview(titleLabel)
        personScrollView.addSubview(personalImage)
        personScrollView.addSubview(userNameLabel)
        personScrollView.addSubview(userNameFiled)
        personScrollView.addSubview(genderLabel)
        personScrollView.addSubview(genderSelectButton)
//        personScrollView.addSubview(petTableCell)
//        personScrollView.addSubview(creatPetBtn)
        personScrollView.addSubview(livingArea)
        personScrollView.addSubview(livingAreaMenuBtn)
        personScrollView.addSubview(introductionLabel)
        personScrollView.addSubview(introductionTextView)
    }
    
    
    
    @objc private func didTapCreatPetBtn() {
        // 創建 PetVC 實例
        let petVC = PetTabViewController()
        // 設置以全畫面顯示
        petVC.modalPresentationStyle = .fullScreen
        // 使用 navigationController 進行跳轉（如果您的 PersonalVC 嵌入在 UINavigationController 中）
        navigationController?.pushViewController(petVC, animated: true)
    }
    
    // MARK: SaveBtn
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
        
        // 將選擇的圖像轉換為 Data
        // 處理圖像選擇後的操作，並將圖像轉換為 Data
        if let selectedImage = personalImage.image,
           let imageData = selectedImage.jpegData(compressionQuality: 0.7) {
            
            DispatchQueue.main.async {
                // 更新畫面程式
                self.uploadImageToServer(imageData: imageData) { result in
                    switch result {
                    case .success(let imagePath):
                        // 成功上傳圖像，imagePath 包含伺服器端文件的路徑
                        print("伺服器返回的圖像路徑：\(imagePath)")
                        
                        // 在這裡處理成功後的邏輯，例如更新用戶頭像
                        // 可以在主線程中更新 UI
                        DispatchQueue.main.async {
                            self.personalImage.image = selectedImage // 更新圖像
                            UserDataManager.shared.userData["Photo"] = imagePath
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
                        
                    case .failure(let error):
                        // 上傳失敗，處理錯誤
                        print("上傳圖像失敗：\(error.localizedDescription)")
                    }
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
            // 將選擇的圖像設置到personalImage
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
    
    // 上傳圖像資料到後端伺服器
    func uploadImageToServer(imageData: Data, completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        guard let userID = UserDataManager.shared.userData["UserID"] as? Int else {
            return
        }
        
        let uniqueFileName = "personImageWith\(userID).jpg"
        print("uniqueFileName = \(uniqueFileName)")
        
        guard let uploadImageUrl = URL(string: "\(ServerApiHelper.shared.updatePhotoUrl)/\(uniqueFileName)") else {
            return
        }
        
        var request = URLRequest(url: uploadImageUrl)
        request.httpMethod = "POST"
        
        // 設置HTTP標頭
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // 創建HTTP主體
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(uniqueFileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let imagePath = json["imagePath"] as? String {
                        completionHandler(.success(imagePath))
                        UserDataManager.shared.userData["Photo"] = "/uploads/\(uniqueFileName)"
                        print("UserPhoto = \(uniqueFileName)")
                    } else {
                        completionHandler(.failure(NSError(domain: "Invalid JSON response", code: 0, userInfo: nil)))
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        
        task.resume()
    }

}

extension PersonalVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        // 計算新的 textView 高度
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // 設定最高度
        let mixHeight: CGFloat = 200.0
        
        if newSize.height >= mixHeight {
            introductionTextViewHeightConstraint.constant = newSize.height
        } else {
            introductionTextViewHeightConstraint.constant = mixHeight
        }
        
        // 更新 scrollView 的內容大小
        personScrollView.contentSize.height = introductionTextView.frame.maxY + 100
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 檢查當前文字長度
            let currentText = textView.text as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: text)
            
            // 如果超過 300 字，就不允許輸入
            return updatedText.count <= 300
    }
    
}
