import UIKit

class PetTabViewController: UIViewController {
    
    
    
    private let petTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.rowHeight = UITableView.automaticDimension
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
        petTable.delegate = self
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
extension PetTabViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 當用戶點擊單元格時，執行以下代碼
        let petInformationEditVC = PetInformationEditVC() // 創建PetInformationEditVC實例
        let selectedPet = UserDataManager.shared.petsData[indexPath.row]
        petInformationEditVC.selectedPet = selectedPet // 設置選定的寵物信息

        // 在這裡將 PetInformationEditVC 壓入導航堆疊
        navigationController?.pushViewController(petInformationEditVC, animated: true)
    }

    
    
}





