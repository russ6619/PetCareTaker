//
//  TaskPetInformationVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/10/3.
//

import UIKit

class TaskPetInformationVC: UIViewController {

    var selectedPet: PetData!
    
    private let petTable: UITableView = {
        let table = UITableView()
        return table
    }()
    
    // 在此處定義您的表單項目
    let sectionTitles: [String] = ["寵物名稱", "寵物簡介或注意事項", "性別", "種類", "尺寸", "出生日期", "是否結紮", "是否規律施打疫苗", "個性"]
    
    
    private let petNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let petPrecautions: UITextView = {
        let text = UITextView()
        return text
    }()
    
    private let petTypeAndSizeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let petAgeAndGenderLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let petNeuteredLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let petVaccinatedLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let petPersonalityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // 創建並設置 tableView
        petTable.dataSource = self
        petTable.delegate = self
        petTable.frame = view.bounds // 確保 tableView 填滿整個視圖
        petTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(petTable)
        
    }

}

// MARK: UITableView
extension TaskPetInformationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回寵物數據的總數
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let sectionTitle = sectionTitles[indexPath.section]
        var cellContent = ""
        
        switch sectionTitle {
        case "寵物名稱":
            cellContent = selectedPet.name
        case "寵物簡介或注意事項":
            cellContent = selectedPet.precautions
        case "性別":
            cellContent = selectedPet.gender
        case "種類":
            cellContent = selectedPet.type
        case "尺寸":
            cellContent = selectedPet.size
        case "出生日期":
            cellContent = selectedPet.birthDate
        case "是否結紮":
            cellContent = selectedPet.neutered
        case "是否規律施打疫苗":
            cellContent = selectedPet.vaccinated
        case "個性":
            cellContent = selectedPet.personality
        default:
            break
        }
        
        cell.textLabel?.text = cellContent
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 當用戶點擊單元格時，執行以下代碼
        tableView.deselectRow(at: indexPath, animated: true) //取消選取
    }
    
    
}
