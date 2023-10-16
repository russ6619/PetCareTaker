//
//  TaskPublisherInformationCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/10/4.
//

import UIKit

class TaskPublisherInformationCell: UITableViewCell {

    private var userImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private var userLivingAreaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    private var userPhoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    private var userIntroductionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 在這裡添加視圖到 cell 中
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userLivingAreaLabel)
        contentView.addSubview(userPhoneLabel)
        contentView.addSubview(userIntroductionLabel)
        
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userLivingAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        userPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        userIntroductionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel.numberOfLines = 0
        userLivingAreaLabel.numberOfLines = 0
        userIntroductionLabel.numberOfLines = 0
        

        
        NSLayoutConstraint.activate([
            // 設置 userImageView 的約束
            userImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: 100),
            userImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // 設置 userNameLabel 的約束
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 10),
            userNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 設置 userLivingAreaLabel 的約束
            userLivingAreaLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userLivingAreaLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
//            userLivingAreaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // 設置 userPhoneLabel 的約束
            userPhoneLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userPhoneLabel.topAnchor.constraint(equalTo: userLivingAreaLabel.bottomAnchor, constant: 10),
            
            // 設置 userIntroductionLabel 的約束
            userIntroductionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userIntroductionLabel.topAnchor.constraint(equalTo: userPhoneLabel.bottomAnchor, constant: 10),
            userIntroductionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with user: UserData, image: UIImage) {
        userNameLabel.text = user.name
        userLivingAreaLabel.text = user.residenceArea
        userPhoneLabel.text = user.phone
        userIntroductionLabel.text = user.introduction
        userImageView.image = image
        
        userImageView.contentMode = .scaleAspectFill // 設置圖片內容模式
        userImageView.clipsToBounds = true // 裁剪圖片以適應圓形邊界
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
    }
    
    
}
