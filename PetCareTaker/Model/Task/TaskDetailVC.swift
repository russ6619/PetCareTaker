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
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constraints.cornerRadious
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.orange.cgColor
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    
    private var taskStartToEndDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()
    
    private var taskPublisherInfo: UIButton = {
        let button = UIButton()
        button.setTitle("發佈者資訊", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 24
        return button
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
        taskPublisherInfo.translatesAutoresizingMaskIntoConstraints = false
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
            taskInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskInfoLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 10),
            taskInfoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            // 設置 taskDeadlineLabel 的約束
            taskDeadlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDeadlineLabel.bottomAnchor.constraint(equalTo: taskPublisherInfo.topAnchor, constant: -10),
            
            // 設置 taskRewardLabel 的約束
            taskRewardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskRewardLabel.bottomAnchor.constraint(equalTo: taskDeadlineLabel.topAnchor, constant: -5),
            
            // 設置 taskPublisherInfo 的約束
            taskPublisherInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            taskPublisherInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            taskPublisherInfo.widthAnchor.constraint(equalToConstant: 141),
            taskPublisherInfo.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        updateLabel()
        addSubviewToView()
        taskPublisherInfo.addTarget(self, action: #selector(showTaskPublisherInfo), for: .touchUpInside)
        
    }
    
    @objc func showTaskPublisherInfo() {
        // 跳轉到 PetInformationEditVC，並將選定的寵物設置為新建立的寵物
        let taskPublisherInfoVC = TaskPublisherInfoVC()
        
        UserDataManager.shared.queryUserInfoByID(userID: selectedTask.PublisherID) { result in
            switch result {
            case .success(let userDataResponse):
                // 從 userDataResponse 獲取使用者資料
                let userInfo = userDataResponse.userData
                // 將使用者資料設置給 taskPublisherInfoVC 的 userInfo 屬性
                taskPublisherInfoVC.userInfo = userInfo
                
                // 從 userDataResponse 獲取寵物資料
                let userPets = userDataResponse.petsData
                // 將寵物資料設置給 taskPublisherInfoVC 的 userPetsInfo 屬性
                taskPublisherInfoVC.userPetsInfo = userPets
                
                // 在這裡執行跳轉操作
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(taskPublisherInfoVC, animated: true)
                }
            case .failure(let error):
                print("queryUserInfoByID 錯誤：\(error)")
            }
        }
    }
    
    private func addSubviewToView() {
        
        view.addSubview(taskNameLabel)
        view.addSubview(taskInfoLabel)
        view.addSubview(taskStartToEndDateLabel)
        view.addSubview(taskPublisherInfo)
        view.addSubview(taskDeadlineLabel)
        view.addSubview(taskRewardLabel)
        
    }

    private func updateLabel() {
        
        guard let startDate = dateFormatter(selectedTask.StartDate),
              let endDate = dateFormatter(selectedTask.EndDate),
              let deadlineDate = dateFormatter(selectedTask.TaskDeadline) else {
            return
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
