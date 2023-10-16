//
//  petPersonalityTableVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/15.
//

import UIKit

protocol PetPersonalitySelectionDelegate: AnyObject {
    func didSelectPersonalityOptions(_ selectedOptions: [String])
}

class petPersonalityTableVC: UITableViewController {
    
    var personalityOptions: [String] = ["熱情", "友善", "聰明", "活潑", "文靜", "害羞", "黏人", "膽小", "勇敢", "貪吃", "敏感", "固執", "頑皮"]
    var selectedOptions: [String] = [] // 用於存儲選擇的項目
    weak var delegate: PetPersonalitySelectionDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊 "personalityCell" 這個 cell 類型
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "personalityCell")
        
        // 設置右上角的 "清除全部" 按鈕
        let clearAllButton = UIBarButtonItem(title: "清除全部", style: .plain, target: self, action: #selector(clearAllSelections))
        navigationItem.rightBarButtonItem = clearAllButton
        
        let backButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    // 清除所有選項
    @objc func clearAllSelections() {
        selectedOptions.removeAll()
        tableView.reloadData()
    }
    
    @objc func backButtonTapped() {
        // 完成選擇，將選擇的項目通知給代理
        delegate?.didSelectPersonalityOptions(selectedOptions)
        // 調用 PetInformationEditVC 中的更新方法
        if let editVC = navigationController?.viewControllers.first(where: { $0 is PetInformationEditVC }) as? PetInformationEditVC {
            editVC.updatePetPersonality(with: selectedOptions)
            
        }
        delegate?.didSelectPersonalityOptions(selectedOptions)
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personalityOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalityCell", for: indexPath)
        
        // 設置 cell 的內容
        cell.textLabel?.text = personalityOptions[indexPath.row]
        
        let selectedOption = personalityOptions[indexPath.row]
        
        // 根據 selectedOptions 陣列中是否包含該選項來設置 Accessory
        if selectedOptions.contains(selectedOption) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = personalityOptions[indexPath.row]
        
        // 切換選項的選擇狀態
        if selectedOptions.contains(selectedOption) {
            if let index = selectedOptions.firstIndex(of: selectedOption) {
                selectedOptions.remove(at: index)
            }
        } else {
            selectedOptions.append(selectedOption)
        }
        
        // 重新加載點選的行，以刷新勾選狀態
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // 返回前一個畫面時將選擇的項目通知給代理
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !selectedOptions.isEmpty {
            delegate?.didSelectPersonalityOptions(selectedOptions)
        }
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
