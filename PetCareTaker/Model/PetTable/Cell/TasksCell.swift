//
//  TasksCell.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/20.
//

import UIKit

class TasksCell: UITableViewCell {
    
    private var taskDeadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private var taskDateIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "calendar.badge.clock")
        image.image?.withTintColor(UIColor.systemGreen)
        return image
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

        contentView.addSubview(taskDateIcon)
        contentView.addSubview(taskDeadlineLabel)
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(taskDateLabel)
        contentView.addSubview(taskRewardLabel)
        
        taskDateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskRewardLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDateIcon.translatesAutoresizingMaskIntoConstraints = false
        
        taskDateLabel.numberOfLines = 0
        taskDeadlineLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            // 設置 taskDateIcon 的約束
            taskDateIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            taskDateIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            taskDateIcon.widthAnchor.constraint(equalToConstant: 36),
            taskDateIcon.heightAnchor.constraint(equalToConstant: 36),
            
            // 設置 taskDeadlineLabel 的約束
            taskDeadlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            taskDeadlineLabel.topAnchor.constraint(equalTo: taskDateIcon.bottomAnchor, constant: 0),
            taskDeadlineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            taskDeadlineLabel.widthAnchor.constraint(equalToConstant: 80),
            
            // 設置 taskNameLabel 的約束
            taskNameLabel.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            // 設置 taskDateLabel 的約束
            taskDateLabel.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskDateLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 5),
            
            // 設置 taskRewardLabel 的約束
            taskRewardLabel.leadingAnchor.constraint(equalTo: taskDeadlineLabel.trailingAnchor, constant: 10),
            taskRewardLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            taskRewardLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    
    
    func configure(date: String, taskName: String, reward: String, deadline: String,imageColor: UIColor) {
        taskDateLabel.text = date
        taskNameLabel.text = taskName
        taskRewardLabel.text = "NT$ \(reward)"
        taskDeadlineLabel.text = deadline
        taskDateIcon.image?.withTintColor(imageColor)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
