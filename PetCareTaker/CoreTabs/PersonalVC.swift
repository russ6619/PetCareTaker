//
//  PersonalVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/31.
//

import UIKit

class PersonalVC: UIViewController, UITextFieldDelegate {
    
    var cities: [City] = []  // 解析後的資料陣列
    var userData: [String: Any] = [:]

    
    struct Constraints {    // 圓角
        static let cornerRadious: CGFloat = 8.0
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true // 垂直滾動條
        return scrollView
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
        image.image = UIImage(systemName: "person.circle")
        image.layer.borderWidth = 1.0 // 外框線寬度
        image.layer.borderColor = UIColor.black.cgColor // 外框線顏色
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
    
    private let petTableCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "petcell")
        cell.imageView?.image = UIImage(systemName: "pawprint.fill")
        cell.textLabel?.text = "編輯寵物資訊"
        cell.selectionStyle = .default
        cell.layer.borderWidth = 1.0 // 外框線寬度
        cell.layer.borderColor = UIColor.black.cgColor // 外框線顏色
        return cell
    }()
    
    private let creatPetBtn: UIButton = {
       let button = UIButton()
        button.setTitle( "新增寵物欄位", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = Constraints.cornerRadious
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.blue.cgColor
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
    
    private let livingAreaPicker: UIPickerView = {
        let picker = UIPickerView()
//        picker.layer.borderWidth = 1.0 // 外框線寬度
//        picker.layer.borderColor = UIColor.black.cgColor // 外框線顏色
        return picker
    }()
    
    private let introduction: UITextView = {
        let text = UITextView()
        text.textColor = .label
        text.text = "請輸入自我介紹"
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.black.cgColor
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        livingAreaPicker.delegate = self
        livingAreaPicker.dataSource = self
        userNameFiled.delegate = self
        
        if let data = NSDataAsset(name: "taiwanDistricts")?.data {
            do {
                cities = try JSONDecoder().decode([City].self, from: data)
                livingAreaPicker.reloadAllComponents()
            } catch {
                print("JSON decoding error: \(error)")
            }
        }
        view.backgroundColor = .systemBackground
        
        addSubviewToScrollView()
        
        let initialRowComponent0 = cities.count / 2 // 中間的城市
        let initialRowComponent1 = cities[initialRowComponent0].districts.count / 2 // 中間的行政區
        livingAreaPicker.selectRow(initialRowComponent0, inComponent: 0, animated: false)
        livingAreaPicker.selectRow(initialRowComponent1, inComponent: 1, animated: false)
        
        creatPetBtn.addTarget(self, action: #selector(didTapCreatPetBtn), for: .touchUpInside)
        
        fetchUserData()
        print(userData)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds // 設置 scrollView 的框架為整個視圖
        scrollView.contentSize = CGSize(width: view.width, height: introduction.bottom + 20) // 設置內容大小
        
        titleLabel.frame = CGRect(
            x: view.xCenter - titleLabel.width / 2.0,
            y: 10,
            width: 162,
            height: 48)

        // 設定 petImage 位置，在 petTitleLabel 下面靠左
        personalImage.frame = CGRect(
            x: 45,
            y: titleLabel.bottom + 30.0,
            width: 150,
            height: 150)

        // 設定 petNameLabel 位置，在 petImage 右邊，在 title 下方
        userNameLabel.frame = CGRect(
            x: 0,
            y: titleLabel.bottom + 10,
            width: 60,
            height: 40)
        userNameLabel.center.x = personalImage.right + (view.width - personalImage.right) / 2

        // 設定 petNameFiled 位置，在 petNameLabel 下面，中心點與 petNameLabel 對齊
        userNameFiled.frame = CGRect(
            x: 0,
            y: userNameLabel.bottom + 5,
            width: view.width - personalImage.right - 60,
            height: 40)
        userNameFiled.center.x = userNameLabel.center.x

        // 設定 genderLabel 位置，在 petNameFiled 下方，與 petNameLabel 左右對齊
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
            width: userNameFiled.width,
            height: 40)
        genderSelectButton.center.x = genderLabel.center.x


        // 設定 petTableCell 位置，在 genderSelectButton 下方，水平置中
        petTableCell.frame = CGRect(
            x: view.xCenter - petTableCell.width / 2,
            y: genderSelectButton.bottom + 20,
            width: petTableCell.width,
            height: petTableCell.height)

        // 設定 creatPetBtn 位置，在 petTableCell 下方，水平置中
        creatPetBtn.frame = CGRect(
            x: view.xCenter - creatPetBtn.width / 2.0,
            y: petTableCell.bottom + 10,
            width: 200,
            height: 36)

        // 設定 petType 位置，在 creatPetBtn 下方，水平置中
        livingArea.frame = CGRect(
            x: view.xCenter - livingArea.width / 2,
            y: creatPetBtn.bottom + 10,
            width: 100,
            height: 36)

        // 設定 petTypePicker 位置，在 petType 下方，水平置中
        livingAreaPicker.frame = CGRect(
            x: view.xCenter - livingAreaPicker.width / 2,
            y: livingArea.bottom,
            width: livingAreaPicker.width,
            height: livingAreaPicker.height)

        // 設定 introduction 位置，在 petTypePicker 下方，水平置中
        introduction.frame = CGRect(
            x: view.xCenter - introduction.width / 2,
            y: livingAreaPicker.bottom + 5,
            width: view.width - 100,
            height: 600)

    }

    
    
    private func addSubview() {
        view.addSubview(titleLabel)
        view.addSubview(personalImage)
        view.addSubview(userNameLabel)
        view.addSubview(userNameFiled)
        view.addSubview(genderLabel)
        view.addSubview(genderSelectButton)
        view.addSubview(petTableCell)
        view.addSubview(creatPetBtn)
        view.addSubview(livingArea)
        view.addSubview(livingAreaPicker)
        view.addSubview(introduction)
    }
    
    private func addSubviewToScrollView() {
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(personalImage)
        scrollView.addSubview(userNameLabel)
        scrollView.addSubview(userNameFiled)
        scrollView.addSubview(genderLabel)
        scrollView.addSubview(genderSelectButton)
        scrollView.addSubview(petTableCell)
        scrollView.addSubview(creatPetBtn)
        scrollView.addSubview(livingArea)
        scrollView.addSubview(livingAreaPicker)
        scrollView.addSubview(introduction)
        view.addSubview(scrollView)
    }
    
    @objc private func didTapCreatPetBtn() {
        // 創建 PetVC 實例
        let petVC = PetTabViewController()
        
        // 設置以全畫面顯示
        petVC.modalPresentationStyle = .fullScreen
        
        // 使用 navigationController 進行跳轉（如果您的 PersonalVC 嵌入在 UINavigationController 中）
        navigationController?.pushViewController(petVC, animated: true)
    }
    
    func fetchUserData() {
        // 使用 queryUserUrl 從PHP後端獲取用戶數據
        guard let userAccount = AuthManager.shared.getUserAccountFromKeychain(),
              let url = URL(string: ServerApiHelper.shared.queryUserUrl + "?Phone=" + userAccount) else {
            return
        }

        // 創建URL請求
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // 發起網絡請求
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("網絡請求錯誤: \(error)")
                return
            }

            // 解析從PHP後端返回的數據
            if let data = data {
                do {
                    if let userData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // 將用戶資料存儲到 userData 中
                        self.userData = userData
                    }
                } catch {
                    print("JSON解析錯誤: \(error)")
                }
            }
        }.resume()
    }

}


// MARK: UIPickerView
extension PersonalVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cities.count
        } else {
            let cityRow = pickerView.selectedRow(inComponent: 0)
            return cities[cityRow].districts.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cities[row].name
        } else {
            let cityRow = pickerView.selectedRow(inComponent: 0)
            return cities[cityRow].districts[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
    
    
}
