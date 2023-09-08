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
    
    struct Constraints {    // 圓角
        static let cornerRadious: CGFloat = 8.0
    }
    
    private let personScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true // 垂直滾動條
        scrollView.isScrollEnabled = true
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
    
    
    private let introductionTextView: UITextView = {
        let text = UITextView()
        text.textColor = .label
        text.text = "請輸入自我介紹"
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.black.cgColor
        text.addBottomBorder(borderColor: UIColor.systemGray.cgColor, borderWidth: text.width - 30)
        text.addCharCalculator(max: 300)
        return text
    }()
    
    
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
        
        addSubviewToScrollView()
        
        guard let name = UserDataManager.shared.userData["Name"] as? String,
              let introduction = UserDataManager.shared.userData["Introduction"] as? String,
              let residenceArea = UserDataManager.shared.userData["ResidenceArea"] as? String,
              let gender = UserDataManager.shared.userData["Gender"] as? String else { return }
        print(name, introduction, residenceArea, gender)
        userNameFiled.text = name
        introductionTextView.text = introduction
        livingAreaMenuBtn.setTitle(residenceArea, for: .normal)
        
        
        if gender == "Male,男" {
            genderSelectButton.selectedSegmentIndex = 0
        } else if gender == "Female,女" {
            genderSelectButton.selectedSegmentIndex = 1
        }
        
        
        creatPetBtn.addTarget(self, action: #selector(didTapCreatPetBtn), for: .touchUpInside)
        
        
                
    }
    
    
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
            width: view.width - personalImage.right - 40,
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
            x: 0,
            y: petTableCell.bottom + 10,
            width: 200,
            height: 36)
        creatPetBtn.center.x = view.xCenter
        
        // 設定 petType 位置，在 creatPetBtn 下方，水平置中
        livingArea.frame = CGRect(
            x: 0,
            y: creatPetBtn.bottom + 10,
            width: 100,
            height: 36)
        livingArea.center.x = view.xCenter
        
        // 設定 livingAreaMenuBtn 位置，在 petType 下方，水平置中
        livingAreaMenuBtn.frame = CGRect(
            x: view.xCenter - 75,
            y: livingArea.bottom,
            width: 150,
            height: 50)
        
        
        // 設定 introductionTextView 位置，在 petTypePicker 下方，水平置中
        introductionTextView.frame = CGRect(
            x: 0,
            y: livingAreaMenuBtn.bottom + 5,
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
        personScrollView.addSubview(petTableCell)
        personScrollView.addSubview(creatPetBtn)
        personScrollView.addSubview(livingArea)
        personScrollView.addSubview(livingAreaMenuBtn)
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
    
    
        
}


