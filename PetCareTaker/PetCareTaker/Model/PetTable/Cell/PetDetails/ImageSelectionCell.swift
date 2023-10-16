//
//  ImageSelectionCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/12.
//

import UIKit

class ImageSelectionCell: UITableViewCell {
    
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setTitle( "請先選擇寵物的大頭照因為會刷新畫面", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.contentVerticalAlignment = .center
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 添加 UIButton 作為子視圖
        contentView.addSubview(imageButton)
        
        // Initialize the button
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupButton() {
        // Set the target after 'delegate' is available
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        
        // Add the button to the contentView and set constraints
        contentView.addSubview(imageButton)
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    weak var delegate: ImageSelectionCellDelegate?
    
    @objc func selectImage() {
        print("Select Image button tapped")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        delegate?.presentImagePicker(imagePicker)
    }
    
}

extension ImageSelectionCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // 將選擇的圖像設置給 petInfo，這裡假設 petInfo 是在 PetInformationEditVC 中訪問的
            delegate?.updatePetImage(selectedImage)
        }
        
        // 關閉UIImagePicker
        picker.dismiss(animated: true, completion: nil)
    }
}
