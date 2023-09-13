import UIKit

class PetTableViewCell: UITableViewCell {
    
    private var petImageView: UIImageView = {
        let image = UIImageView()
        // 設置圖像視圖的佈局，例如位置、大小、內邊距等
        // 例如：image.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        // 你可以使用 Auto Layout 或 frame 來配置視圖的佈局
        return image
    }()
    
    private var petNameLabel: UILabel = {
        let label = UILabel()
        // 設置標籤的佈局，例如位置、大小、內邊距、字體等
        // 例如：label.frame = CGRect(x: 100, y: 10, width: 200, height: 30)
        // 你可以使用 Auto Layout 或 frame 來配置視圖的佈局
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private var petBasicLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var petPersonalityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.systemBlue
        return label
    }()
    
    private var petDetailedLabel: UILabel = {
        let label = UILabel()
        // 設置標籤的佈局，例如位置、大小、內邊距、字體等
        // 例如：label.frame = CGRect(x: 100, y: 50, width: 200, height: 20)
        // 你可以使用 Auto Layout 或 frame 來配置視圖的佈局
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.systemRed
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 在這裡添加視圖到 cell 中
        contentView.addSubview(petImageView)
        contentView.addSubview(petNameLabel)
        contentView.addSubview(petBasicLabel)
        contentView.addSubview(petPersonalityLabel)
        contentView.addSubview(petDetailedLabel)
        
        // 設置視圖的佈局，例如 Auto Layout 約束或 frame
        // 例如，使用 Auto Layout:
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        petBasicLabel.translatesAutoresizingMaskIntoConstraints = false
        petPersonalityLabel.translatesAutoresizingMaskIntoConstraints = false
        petDetailedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        petNameLabel.numberOfLines = 0
        petBasicLabel.numberOfLines = 0
        petPersonalityLabel.numberOfLines = 0
        petDetailedLabel.numberOfLines = 0

        
        NSLayoutConstraint.activate([
            // 設置 petImageView 的約束
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            petImageView.widthAnchor.constraint(equalToConstant: 80),
            petImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 設置 petNameLabel 的約束
            petNameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // 設置 petBasicLabel 的約束
            petBasicLabel.leadingAnchor.constraint(equalTo: petNameLabel.trailingAnchor, constant: 10),
            petBasicLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // 設置 petPersonalityLabel 的約束
            petPersonalityLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petPersonalityLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor, constant: 5),
            
            // 設置 petDetailedLabel 的約束
            petDetailedLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petDetailedLabel.topAnchor.constraint(equalTo: petPersonalityLabel.bottomAnchor, constant: 5),
            petDetailedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with pet: Pet) {
        // 在這裡設置視圖的內容
        var neutered = "已結紮"
        var vaccinated = "有規律施打疫苗"
        
        if pet.neutered != "0" {
            neutered = "尚未結紮"
        }
        
        if pet.vaccinated != "1" {
            vaccinated = "沒有規律施打疫苗"
        }
        
//        petImageView.image = UIImage(named: pet.photo)
        petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        petNameLabel.text = pet.name
        petBasicLabel.text = "\(pet.type), \(pet.breed), \(calculateAge(from: pet.birthDate)), \(pet.gender),  \(pet.size)"
        petPersonalityLabel.text = "\(pet.personality), \(pet.habits)"
        petDetailedLabel.text = "\(neutered), \(vaccinated)"
    }

    private func calculateAge(from birthDate: String) -> String {
        // 在這裡計算年齡，並返回合適的字符串
        // 你需要解析出生日期並計算年齡
        // 返回類似 "3歲" 的字符串
        return "3歲" // 這只是一個示例
    }
}
