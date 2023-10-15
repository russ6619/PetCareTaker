//
//  PublishedTaskTableVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/25.
//

import UIKit

class PublishedTaskTableVC: UITableViewController {
    
    var userPublishedTasks: [Tasks] = []
    let userID: String = String(UserDataManager.shared.userData["UserID"] as! Int)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.register(TaskForSelfCell.self, forCellReuseIdentifier: "TaskForSelfCell")
        
        // 訂閱通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name(rawValue: "TaskAddedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name(rawValue: "TaskUpdatedNotification"), object: nil)
        
        userPublishedTasks = UserDataManager.shared.selfTaskData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // 啟用編輯模式
        self.editButtonItem.title = "編輯"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if notification.name == NSNotification.Name(rawValue: "TaskAddedNotification") {
            // 處理新增任務的操作
            reloadData()
        } else if notification.name == NSNotification.Name(rawValue: "TaskUpdatedNotification") {
            // 處理更新任務的操作
            reloadData()
        }
    }
    
    @objc func reloadData() {
        // 在這裡重新加載資料和刷新表格
        print("userID = \(userID)")
        UserDataManager.shared.fetchTaskDataFromID(publisherID: userID) { error in
            if let error = error {
                print("無法獲取發佈清單，錯誤：\(error.localizedDescription)")
            } else {
                // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                print("發佈任務下載成功")
                self.userPublishedTasks = UserDataManager.shared.selfTaskData
            }
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userPublishedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskForSelfCell", for: indexPath) as! TaskForSelfCell
        
        // 獲取特定索引處的任務
        let task = UserDataManager.shared.selfTaskData[indexPath.row]
        
        guard let startDate = dateFormatter(task.StartDate),
              let endDate = dateFormatter(task.EndDate) else {
            return cell
        }
        
        let remainingTime = calculateRemainingTime(from: task.TaskDeadline)
        
        // 設置自定義cell的內容
        let dateString = "\(startDate.month) ～ \(endDate.month)"
        let rewardString = "\(formatNumberString(task.TaskReward))"
        var deadline = "任務截止：\n\(remainingTime)"
        if task.TaskStatus == "已過期" {
            deadline = "任務截止：\n已過期"
        }
        let taskinfo = "\(task.TaskInfo)"
        
        cell.configure(date: dateString, taskName: task.TaskName, taskInfo: taskinfo, reward: rewardString, deadline: deadline)
        
        cell.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        cell.layer.shadowOpacity = 0.8 // 陰影不透明度
        cell.layer.shadowOffset = CGSize(width: 2, height: 0) // 陰影偏移量
        cell.layer.shadowRadius = 2 // 陰影半徑
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 獲取選擇的任務
        let selectedTask = userPublishedTasks[indexPath.row]
        
        // 創建 TaskEditVC 實例
        let taskEditVC = TaskEditVC()
        
        // 將選擇的任務資訊傳遞給 TaskEditVC
        taskEditVC.selectedTask = selectedTask
        
        // 使用導航控制器將 TaskEditVC 壓入堆疊以進行編輯
        navigationController?.pushViewController(taskEditVC, animated: true)
    }

    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // 允許所有行進行編輯
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 獲取要刪除的任務
            let task = userPublishedTasks[indexPath.row]
            
            // 構建 DELETE 請求的 URL，將 TaskID 作為參數
            let taskID = task.TaskID
            if let url = URL(string: ServerApiHelper.shared.deleteTasksUrl + "?TaskID=\(taskID)") {
                
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                
                // 發起 DELETE 請求
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        // 處理錯誤
                        print("刪除任務失敗：\(error)")
                    } else {
                        // 刪除成功，更新資料源和表格視圖
                        self.userPublishedTasks.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }.resume()
            }
        }
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
    
    // 計算剩餘時間的函數
    func calculateRemainingTime(from dateString: String) -> String {
        // 創建日期格式化器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 解析日期字符串
        if let deadlineDate = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let now = Date()
            
            // 計算日期差距
            let components = calendar.dateComponents([.year, .month, .day], from: now, to: deadlineDate)
            
            if let years = components.year, let months = components.month, let days = components.day {
                if years > 0 {
                    return "\(years)年\(months)月\(days)天到期"
                } else if months > 0 {
                    return "\(months)月\(days)天到期"
                } else if days > 0 {
                    return "\(days)天到期"
                } else if days == 0{
                    return "今天到期"
                } else {
                    return "已過期"
                }
            }
        }
        
        return ""
    }
    
}
