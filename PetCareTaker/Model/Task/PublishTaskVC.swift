//
//  PublishTaskVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/25.
//

import UIKit

class PublishTaskVC: UIViewController, UITextViewDelegate {
    
    private var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "發佈任務"
        label.font = UIFont.systemFont(ofSize: 28)
        return label
    }()
    
    private var taskNameField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.textColor = .label
        textField.placeholder = "請填寫任務名稱"
        textField.returnKeyType = .continue
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constraints.cornerRadious
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        textField.textAlignment = .center
        return textField
    }()

    private var taskInfoText: WSPlaceholderTextView = {
        let textView = WSPlaceholderTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.placeholder = "請輸入您的任務內容"
        textView.placeholderColor = .gray
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Constraints.cornerRadious
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor
        textView.addBottomBorder(borderColor: UIColor.systemGray.cgColor, borderWidth: textView.width - 30)
        textView.addCharCalculator(max: 300)
        textView.isScrollEnabled = false // 禁用滾動
        textView.textContainerInset = .zero // 清除文本內邊距
        textView.textContainer.lineFragmentPadding = 0 // 清除行內邊距
        return textView
    }()
    
    private var taskDateLabel: UILabel = {
        let label = UILabel()
        label.text = "任務開始與結束日期"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private var taskStartDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 20.0
        return datePicker
    }()
    
    private var taskEndDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 20.0
        return datePicker
    }()
    
    private var taskDeadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "接任務最後期限"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private var taskDeadlineDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 20.0
        return datePicker
    }()
    
    private var taskRewardField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .label
        textField.placeholder = "請填寫任務獎金"
        textField.keyboardType = .numberPad
        textField.returnKeyType = .continue
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constraints.cornerRadious
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        textField.textAlignment = .center
        return textField
    }()
    
    private var publisherBtn: UIButton = {
        let button = UIButton()
        button.setTitle("發佈任務", for: .normal)
        button.titleLabel?.textColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constraints.cornerRadious
        return button
    }()

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        publisherBtn.addTarget(self, action: #selector(editBtnPressed), for: .touchUpInside)

        // Do any additional setup after loading the view.
        addSubviewToView()
        
        taskInfoText.delegate = self
        // 設定返回按鈕的標題
        let backButton = UIBarButtonItem()
        backButton.title = "返回"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameField.translatesAutoresizingMaskIntoConstraints = false
        taskInfoText.translatesAutoresizingMaskIntoConstraints = false
        taskDateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskStartDate.translatesAutoresizingMaskIntoConstraints = false
        taskEndDate.translatesAutoresizingMaskIntoConstraints = false
        taskDeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDeadlineDate.translatesAutoresizingMaskIntoConstraints = false
        taskRewardField.translatesAutoresizingMaskIntoConstraints = false
        publisherBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 設置 taskTitleLabel 的約束
            taskTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            
            // 設置 taskNameField 的約束
            taskNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameField.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 10),
            taskNameField.widthAnchor.constraint(equalToConstant: view.width - 20),
            
            // 設置 taskInfoText 的約束
            taskInfoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            taskInfoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            taskInfoText.topAnchor.constraint(equalTo: taskNameField.bottomAnchor, constant: 10),
            taskInfoText.heightAnchor.constraint(equalToConstant: 100),
            
            // 設置 taskDateLabel 的約束
            taskDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDateLabel.topAnchor.constraint(equalTo: taskInfoText.bottomAnchor, constant: 10),
            
            // 設置 taskStartDate 的約束
            taskStartDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskStartDate.topAnchor.constraint(equalTo: taskDateLabel.bottomAnchor, constant: 10),
            
            // 設置 taskEndDate 的約束
            taskEndDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskEndDate.topAnchor.constraint(equalTo: taskStartDate.bottomAnchor, constant: 10),
            
            // 設置 taskDeadlineLabel 的約束
            taskDeadlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDeadlineLabel.topAnchor.constraint(equalTo: taskEndDate.bottomAnchor, constant: 10),

            
            // 設置 taskDeadlineDate 的約束
            taskDeadlineDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDeadlineDate.topAnchor.constraint(equalTo: taskDeadlineLabel.bottomAnchor, constant: 10),
            
            // 設置 taskRewardField 的約束
            taskRewardField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskRewardField.topAnchor.constraint(equalTo: taskDeadlineDate.bottomAnchor, constant: 10),
            taskRewardField.widthAnchor.constraint(equalToConstant: 150),
            
            // 設置 editBtn 的約束
            publisherBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            publisherBtn.topAnchor.constraint(equalTo: taskRewardField.bottomAnchor, constant: 8),
            publisherBtn.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func addSubviewToView() {
        
        view.addSubview(taskTitleLabel)
        view.addSubview(taskNameField)
        view.addSubview(taskInfoText)
        view.addSubview(taskDateLabel)
        view.addSubview(taskStartDate)
        view.addSubview(taskEndDate)
        view.addSubview(taskDeadlineLabel)
        view.addSubview(taskDeadlineDate)
        view.addSubview(taskRewardField)
        view.addSubview(publisherBtn)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let minHeight: CGFloat = 100.0 // 設定最小高度
        
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: 1000))

        // 根據計算出的高度，更新UITextView的高度約束
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = max(minHeight, size.height)
            }
        }
        
        // 通知Auto Layout重新佈局
        view.layoutIfNeeded()
    }


    // MARK: @objc
    @objc func editBtnPressed() {
        
        // 檢查是否所有欄位都有值
        guard let taskName = taskNameField.text,
              let taskInfo = taskInfoText.text,
              let taskRewardStr = taskRewardField.text,
              !taskName.isEmpty,
              !taskInfo.isEmpty,
              !taskRewardStr.isEmpty,
              let userID: String = UserDataManager.shared.userData["UserID"] as? String else {
            showAlert(title: "錯誤", message: "所有欄位皆必填")
            return
        }
        
        let startDate = taskStartDate.date
        let endDate = taskEndDate.date
        let deadlineDate = taskDeadlineDate.date
        
        // 將日期轉換為字串
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        let deadlineDateString = dateFormatter.string(from: deadlineDate)
        
        // 將任務獎金轉換為數字
        guard let taskReward = Int(taskRewardStr),
        taskReward > 0 else {
            showAlert(title: "錯誤", message: "任務獎金格式錯誤")
            return
        }
        
        let taskData: [String: Any] = [
            "PublisherID": userID, // 這裡可以替換成用戶的實際 ID
            "TaskName": taskName,
            "TaskInfo": taskInfo,
            "TaskDeadline": deadlineDateString,
            "TaskReward": taskReward,
            "StartDate": startDateString,
            "EndDate": endDateString
        ]
        
        UserDataManager.shared.createTask(taskData: taskData) { (error) in
            if let error = error {
                self.showAlert(title: "錯誤", message: "新增任務失敗: \(error.localizedDescription)")
            } else {
                // 成功新增任務，可以執行相關操作，例如返回前一個畫面或者顯示成功訊息
                DispatchQueue.main.async {
                    UserDataManager.shared.fetchTaskDataFromID(publisherID: userID) { error in
                        if let error = error {
                            // 處理錯誤情況，例如顯示錯誤訊息
                            print("無法獲取用戶發佈的任務資料，錯誤：\(error.localizedDescription)")
                        } else {
                            // 用戶任務資料下載成功，可以在這裡處理用戶寵物資料，例如設定 userPetData
                            print("用戶任務資料下載成功：\(UserDataManager.shared.selfTaskData)")
                            // 在成功新增任務後，發送一個通知
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TaskAddedNotification"), object: nil)
                        }
                    }
                }
                DispatchQueue.main.async {
                    // 更新畫面程式
                    self.showAlertMore(title: "成功", message: "新增任務成功") { _ in
                        // 成功更新任務後，返回上一頁
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
            // 更新畫面程式
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
        
    func showAlertMore(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


