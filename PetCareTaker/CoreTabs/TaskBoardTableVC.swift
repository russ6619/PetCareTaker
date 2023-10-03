//
//  TaskBoardTableVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/18.
//

import UIKit

class TaskBoardTableVC: UITableViewController {
    
//    private let filterMenuBtn: UIBarButtonItem = {
//        let button = UIBarButtonItem()
//        button.image = UIImage(systemName: "list.dash")
//        button.menu = UIMenu(children: [
//            UIAction(title: "短期任務", handler: { action in
//            print("短期任務")}),
//            UIAction(title: "長期任務", handler: { action in
//            print("長期任務")}),
//            UIAction(title: "即期任務", handler: { action in
//            print("即期任務")})
//        ])
//        return button
//    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.register(TasksCell.self, forCellReuseIdentifier: "TasksCell")

        // 左上角的 Reload 按鈕
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        navigationItem.leftBarButtonItem = reloadButton
        
        let createdTaskBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createdTask))
        
        navigationItem.rightBarButtonItem = createdTaskBtn
        
        // 訂閱新增任務通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleTaskAddedNotification), name: NSNotification.Name(rawValue: "TaskAddedNotification"), object: nil)
        
        
        // 創建一個容器視圖
        let backgroundContainerView = UIView()
        backgroundContainerView.backgroundColor = UIColor(white: 1, alpha: 0.7) // 設置半透明的背景色

        // 創建UIImageView來顯示背景圖片
        let backgroundImage = UIImageView(image: UIImage(named: "Logo2"))
        backgroundImage.contentMode = .scaleAspectFill

        tableView.backgroundView = backgroundImage

    }
    
    @objc func handleTaskAddedNotification() {
        // 在這裡執行更新數據的操作，例如重新加載表格數據
        reloadData()
    }


    @objc func reloadData() {
        // 在這裡重新加載資料和刷新表格
        
        DispatchQueue.main.async {
            // 更新畫面程式
            UserDataManager.shared.fetchTaskData { error in
                if let error = error {
                    print("無法獲取任務清單，錯誤：\(error.localizedDescription)")
                } else {
                    // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                    print("任務清單更新成功")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func createdTask() {
        
        let publishTaskVC = PublishTaskVC()
        navigationController?.show(publishTaskVC, sender: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserDataManager.shared.tasksData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath) as! TasksCell

        // 獲取特定索引處的任務
        let task = UserDataManager.shared.tasksData[indexPath.row]
        
        guard let startDate = dateFormatter(task.StartDate),
              let endDate = dateFormatter(task.EndDate),
              let deadlineDate = dateFormatter(task.TaskDeadline) else {
            return cell
        }
        
        // 設置自定義cell的內容
        let dateString = "\(startDate.month) ～ \(endDate.month)"
        let rewardString = "\(formatNumberString(task.TaskReward))"
        let deadline = "接受任務期限：\(deadlineDate.month)"
        
        cell.configure(date: dateString, taskName: task.TaskName, reward: rewardString, deadline: deadline)

        cell.layer.shadowColor = UIColor.black.cgColor // 陰影顏色
        cell.layer.shadowOpacity = 0.3 // 陰影不透明度
        cell.layer.shadowOffset = CGSize(width: 2, height: 2) // 陰影偏移量
        cell.layer.shadowRadius = 2 // 陰影半徑
//        cell.backgroundColor = UIColor.clear
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 獲取所選任務
        let selectedTask = UserDataManager.shared.tasksData[indexPath.row]

        // 創建 TaskDetailViewController 的實例
        let taskDetailVC = TaskDetailVC()

        // 傳遞所選任務資料給 TaskDetailViewController
        taskDetailVC.selectedTask = selectedTask

        // 將 TaskDetailViewController 推入導航堆疊，顯示詳細資料
        navigationController?.pushViewController(taskDetailVC, animated: true)
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
