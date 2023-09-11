import UIKit

class PetTabViewController: UIViewController {
    
    
    
    private let petTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        return table
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 創建並設置 tableView
        petTable.dataSource = self
        petTable.frame = view.bounds // 確保 tableView 填滿整個視圖
        petTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 註冊 PetTableViewCell 類別用於表視圖
        petTable.register(PetTableViewCell.self, forCellReuseIdentifier: "PetCell")
        
        // 添加 tableView 到視圖中
        view.addSubview(petTable)
        
        // 其他初始化設置...
        
    }

}

// MARK: tableview
extension PetTabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 返回寵物數據的總數
        return UserDataManager.shared.petsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetTableViewCell
        
        // 獲取特定位置的寵物數據
        let pet = UserDataManager.shared.petsData[indexPath.row]
        
        // 使用 configure 方法設置單元格的內容
        cell.configure(with: pet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let pet = UserDataManager.shared.petsData[indexPath.row] // 假設您有一個pets數組來存儲寵物數據
        let petDetailedText = "\(pet.neutered), \(pet.vaccinated)" // pet的詳細信息文本
        let petDetailedLabelHeight = heightForText(petDetailedText, font: UIFont.boldSystemFont(ofSize: 16), width: tableView.frame.width - 120) // 計算文本的高度
        return 120 + petDetailedLabelHeight // 120是其他元素的高度，根據您的佈局調整
    }


    func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = text.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return ceil(boundingRect.height)
    }


}




struct Constraints {    // 圓角
    static let cornerRadious: CGFloat = 8.0
}


