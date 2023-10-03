//
//  TaskDetailVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/22.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    var selectedTask: Tasks!
    
    private var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()

    private var taskInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private var taskStartToEndDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()
    
    private var taskPublisherPhone: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .label
        return label
    }()
    
    private var taskDeadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .label
        return label
    }()
    
    private var taskRewardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        taskStartToEndDateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskPublisherPhone.translatesAutoresizingMaskIntoConstraints = false
        taskDeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        taskRewardLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 設置 taskStartDateLabel 的約束
            taskStartToEndDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskStartToEndDateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            // 設置 taskNameLabel 的約束
            taskNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskNameLabel.topAnchor.constraint(equalTo: taskStartToEndDateLabel.bottomAnchor, constant: 5),
            
            // 設置 taskInfoLabel 的約束
            taskInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            taskInfoLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 10),
            taskInfoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            // 設置 taskDeadlineLabel 的約束
            taskDeadlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDeadlineLabel.bottomAnchor.constraint(equalTo: taskPublisherPhone.topAnchor, constant: -10),
            
            // 設置 taskRewardLabel 的約束
            taskRewardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskRewardLabel.bottomAnchor.constraint(equalTo: taskDeadlineLabel.topAnchor, constant: -5),
            
            // 設置 taskPublisherPhone 的約束
            taskPublisherPhone.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            taskPublisherPhone.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        updateLabel()
        addSubviewToView()
        
    }
    
    private func addSubviewToView() {
        
        view.addSubview(taskNameLabel)
        view.addSubview(taskInfoLabel)
        view.addSubview(taskStartToEndDateLabel)
        view.addSubview(taskPublisherPhone)
        view.addSubview(taskDeadlineLabel)
        view.addSubview(taskRewardLabel)
        
    }

    private func updateLabel() {
        
        guard let startDate = dateFormatter(selectedTask.StartDate),
              let endDate = dateFormatter(selectedTask.EndDate),
              let deadlineDate = dateFormatter(selectedTask.TaskDeadline) else {
            return
        }
        
        UserDataManager.shared.queryUserPhoneByID(userID: selectedTask.PublisherID) { result in
            switch result {
            case .success(let phone):
                DispatchQueue.main.async {
                    self.taskPublisherPhone.text = "聯絡電話：\(phone)"
                }
            case .failure(let error):
                print("Error fetching phone: \(error)")
            }
        }

        // 此處的程式碼將在上述查詢請求完成之前執行，請確保您的 UI 需求與數據請求同步。
        taskNameLabel.text = selectedTask.TaskName
        taskInfoLabel.text = selectedTask.TaskInfo
        taskStartToEndDateLabel.text = "\(startDate.month)～\(endDate.month)"
        taskDeadlineLabel.text = "\(deadlineDate.month)前可接受任務"
        taskRewardLabel.text = "NT$ \(formatNumberString(selectedTask.TaskReward))"
    }

    
    func dateFormatter(_ dateString: String) -> (year: String, month: String)? {
        // 創建日期格式化器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // 解析日期字符串
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)

            if let year = components.year, let month = components.month, let day = components.day {
                return (year: "\(year)", month: "\(month)/\(day)")
            }
        }
        return nil
    }

    func formatNumberString(_ numberString: String) -> String {
        if let numberValue = Double(numberString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSeparator = ","
            numberFormatter.maximumFractionDigits = 0 // 不顯示小數點
            return numberFormatter.string(from: NSNumber(value: numberValue)) ?? numberString
        } else {
            return numberString
        }
    }

    
}
