//
//  petImageViewCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/12.
//

import UIKit

class petImageViewCell: UITableViewCell {
    
    let petImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill // 設置 contentMode
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 添加 UIButton 作為子視圖
        contentView.addSubview(petImage)
        
        // 設置 UIButton 的約束，根據您的界面設計來調整
        petImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            petImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), 
            petImage.widthAnchor.constraint(equalToConstant: 200), // 設定圖像寬度
            petImage.heightAnchor.constraint(equalToConstant: 200) // 設定圖像高度
        ])
        
        petImage.contentMode = .scaleAspectFill // 設置圖片內容模式
        petImage.layer.cornerRadius = petImage.frame.height / 2
        petImage.layer.masksToBounds = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPetImage(_ image: UIImage?) {
        if let image = image {
            petImage.image = image
            petImage.contentMode = .scaleAspectFill // 設置圖片視圖的內容模式
            petImage.layer.cornerRadius = petImage.frame.height / 2
            petImage.layer.masksToBounds = true
        } else {
            // 如果沒有圖像，設置一個空白圖像或者隱藏 petImage，根據您的需求
            petImage.image = nil
            // 或者隱藏 petImage
            // petImage.isHidden = true
        }
        setNeedsLayout()
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
    }


}
