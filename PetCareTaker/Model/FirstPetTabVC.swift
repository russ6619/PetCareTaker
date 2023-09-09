//
//  FirstPetTabVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/3.
//

import UIKit

class FirstPetTabVC: UIViewController {
    
    struct Constraints {    // 圓角
        static let cornerRadious: CGFloat = 8.0
    }
    
    private let petTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "寵物資訊"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false // 啟用 Auto Layout
        return label
        }()
    
    private let petImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "pawprint.circle.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let petNameLabel: UILabel = {
        let label = UILabel()
        label.text = "名稱"
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let petNameFiled: UITextField = {
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
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderSelectButton: UISegmentedControl = {
        let button = UISegmentedControl()
        button.insertSegment(withTitle: "Male,公", at: 0, animated: false)
        button.insertSegment(withTitle: "Female,母", at: 1, animated: false)
        button.layer.cornerRadius = Constraints.cornerRadious
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let petType: UILabel = {
        let label = UILabel()
        label.text = "品種"
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let petTypePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.layer.borderWidth = 1.0 // 外框線寬度
        picker.layer.borderColor = UIColor.black.cgColor // 外框線顏色
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let introduction: UITextView = {
        let text = UITextView()
        text.textColor = .label
        text.text = "請輸入寵物介紹"
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.systemGray.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.addBottomBorder(borderColor: UIColor.systemBackground.cgColor, borderWidth: text.width - 40)
        text.addCharCalculator(max: 300)
        return text
    }()
    
    func setupConstraints() {
        // 設定 petTitleLabel 的約束
        NSLayoutConstraint.activate([
            petTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            petTitleLabel.heightAnchor.constraint(equalToConstant: 48)
        ])

        // 設定 petImage 的約束
        NSLayoutConstraint.activate([
            petImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            petImage.topAnchor.constraint(equalTo: petTitleLabel.bottomAnchor, constant: 30),
            petImage.widthAnchor.constraint(equalToConstant: 150),
            petImage.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        petImage.contentMode = .scaleAspectFill
        petImage.clipsToBounds = true
        petImage.layer.cornerRadius = petImage.frame.size.width / 2
        
        
        // 設定 petNameLabel 的約束
        NSLayoutConstraint.activate([
            petNameLabel.topAnchor.constraint(equalTo: petTitleLabel.bottomAnchor, constant: 10),
            petNameLabel.leadingAnchor.constraint(equalTo: petImage.trailingAnchor, constant: 70),
            petNameLabel.widthAnchor.constraint(equalToConstant: 60),
            petNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        // 設定 petNameFiled 的約束
        NSLayoutConstraint.activate([
            petNameFiled.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor, constant: 5),
            petNameFiled.centerXAnchor.constraint(equalTo: petNameLabel.centerXAnchor, constant: 0),
            petNameFiled.widthAnchor.constraint(equalToConstant: view.width - petImage.right - 240),
            petNameFiled.heightAnchor.constraint(equalToConstant: 40)
        ])

        // 設定 genderLabel 的約束
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: petNameFiled.bottomAnchor, constant: 10),
            genderLabel.centerXAnchor.constraint(equalTo: petNameLabel.centerXAnchor, constant: 0),
            genderLabel.widthAnchor.constraint(equalToConstant: 60),
            genderLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        // 設定 genderSelectButton 的約束
        NSLayoutConstraint.activate([
            genderSelectButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5),
            genderSelectButton.centerXAnchor.constraint(equalTo: petNameLabel.centerXAnchor, constant: 0),
            genderSelectButton.trailingAnchor.constraint(equalTo: petNameFiled.trailingAnchor),
            genderSelectButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        // 設定 petType 的約束
        NSLayoutConstraint.activate([
            petType.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 10),
            petType.centerXAnchor.constraint(equalTo: petTitleLabel.centerXAnchor, constant: 0),
            petType.widthAnchor.constraint(equalToConstant: 60),
            petType.heightAnchor.constraint(equalToConstant: 40)
        ])

        // 設定 petTypePicker 的約束
        NSLayoutConstraint.activate([
            petTypePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petTypePicker.topAnchor.constraint(equalTo: petType.bottomAnchor),
            // 添加其他適當的寬度和高度約束
        ])

        // 設定 introductionTextView 的約束
        NSLayoutConstraint.activate([
            introduction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introduction.topAnchor.constraint(equalTo: petTypePicker.bottomAnchor, constant: 10),
            introduction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50), // 左邊距離 view.leading 50 個點
            introduction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50), // 右邊距離 view.trailing 50 個點
            introduction.heightAnchor.constraint(equalToConstant: 600) // 固定高度為 600
        ])
        
    }

    
    private func addSubview() {
        view.addSubview(petTitleLabel)
        view.addSubview(petImage)
        view.addSubview(petNameLabel)
        view.addSubview(petNameFiled)
        view.addSubview(genderLabel)
        view.addSubview(genderSelectButton)
        view.addSubview(petType)
        view.addSubview(petTypePicker)
        view.addSubview(introduction)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubview()
        setupConstraints()
        // 添加image點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePickerBtnPressed))
        petImage.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func imagePickerBtnPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self 
        imagePicker.sourceType = .photoLibrary // 或者 .camera，視需要選擇相冊或相機
        print("imagePressedToPicker")
        // 開啟圖像選擇器
        present(imagePicker, animated: true, completion: nil)
    }

    
    
}


extension FirstPetTabVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 當用戶選擇了圖像後調用的方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // 在這裡處理選擇的圖像，例如顯示在 personalImage 上
            petImage.image = selectedImage
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
