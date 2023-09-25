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
    }

    @objc func reloadData() {
        // 在這裡重新加載資料和刷新表格
        UserDataManager.shared.fetchTaskData { error in
            if let error = error {
                print("無法獲取任務清單，錯誤：\(error.localizedDescription)")
            } else {
                // 資料下載成功，可以在這裡處理用戶資料，例如更新界面
                print("任務清單下載成功")
            }
        }
        tableView.reloadData()
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
        let deadline = "任務期限：\n\(deadlineDate.month)"
        
        cell.configure(date: dateString, taskName: task.TaskName, reward: rewardString, deadline: deadline, imageColor: UIColor.systemGreen)

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



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
