//
//  TaskForSelfCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/26.
//

import UIKit

class TaskForSelfCell: UITableViewCell {
    
    private var taskDeadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private var taskDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private var taskInfoTextHeightConstraint: NSLayoutConstraint?

    private var taskInfoText: UITextView = {
        let text = UITextView()
        text.font = UIFont.boldSystemFont(ofSize: 16)
        text.textColor = .label
        text.textAlignment = .left
        text.backgroundColor = .secondarySystemBackground
        text.isScrollEnabled = false // 禁用滾動
        text.isUserInteractionEnabled = false
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.masksToBounds = true
        text.layer.cornerRadius = Constraints.cornerRadious
        text.layer.borderWidth = 0.2
        text.layer.borderColor = UIColor.secondaryLabel.cgColor
        text.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        text.layer.shadowOpacity = 0.5 // 陰影不透明度
        text.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        text.layer.shadowRadius = 5 // 陰影半徑
        return text
    }()
    
    private var taskRewardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(taskDeadlineLabel)
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(taskInfoText)
        contentView.addSubview(taskDateLabel)
        contentView.addSubview(taskRewardLabel)
        
        taskDateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskRewardLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        taskInfoText.translatesAutoresizingMaskIntoConstraints = false
        
        taskDateLabel.numberOfLines = 0
        taskDeadlineLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            
            // 設置 taskDeadlineLabel 的約束
            taskDeadlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            taskDeadlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskDeadlineLabel.widthAnchor.constraint(equalToConstant: 80),
            taskDeadlineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            // 設置 taskNameLabel 的約束
            taskNameLabel.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            // 設置 taskInfoText 的約束
            taskInfoText.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskInfoText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskInfoText.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 5),
            
            
            // 設置 taskDateLabel 的約束
            taskDateLabel.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskDateLabel.topAnchor.constraint(equalTo: taskInfoText.bottomAnchor, constant: 5),
            
            // 設置 taskRewardLabel 的約束
            taskRewardLabel.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskRewardLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskRewardLabel.topAnchor.constraint(equalTo: taskDateLabel.bottomAnchor, constant: 5),
            taskRewardLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    
    
    func configure(date: String, taskName: String,taskInfo: String, reward: String, deadline: String) {
        taskDateLabel.text = date
        taskNameLabel.text = taskName
        taskInfoText.text = taskInfo
        taskRewardLabel.text = "NT$ \(reward)"
        taskDeadlineLabel.text = deadline
        
        // 計算 text view 的內容高度
        if taskInfoText.text != nil {
            let size = CGSize(width: taskInfoText.frame.width, height: .infinity)
            let estimatedSize = taskInfoText.sizeThatFits(size)
            
            // 更新高度約束
            taskInfoTextHeightConstraint?.constant = estimatedSize.height
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
