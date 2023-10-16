import UIKit

class PetTableViewCell: UITableViewCell {
    
    private var petImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    private var petNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private var petBasicLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.systemRed
        return label
    }()
    
    private var petPrecautionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
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
        contentView.addSubview(petPrecautionsLabel)
        
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        petBasicLabel.translatesAutoresizingMaskIntoConstraints = false
        petPersonalityLabel.translatesAutoresizingMaskIntoConstraints = false
        petDetailedLabel.translatesAutoresizingMaskIntoConstraints = false
        petPrecautionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        petNameLabel.numberOfLines = 0
        petBasicLabel.numberOfLines = 0
        petPersonalityLabel.numberOfLines = 0
        petDetailedLabel.numberOfLines = 0
        petPrecautionsLabel.numberOfLines = 0

        
        NSLayoutConstraint.activate([
            // 設置 petImageView 的約束
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            petImageView.widthAnchor.constraint(equalToConstant: 80),
            petImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 設置 petNameLabel 的約束
            petNameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            petNameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            // 設置 petBasicLabel 的約束
            petBasicLabel.leadingAnchor.constraint(equalTo: petNameLabel.trailingAnchor, constant: 10),
            petBasicLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            petBasicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // 設置 petPersonalityLabel 的約束
            petPersonalityLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petPersonalityLabel.topAnchor.constraint(equalTo: petBasicLabel.bottomAnchor, constant: 5),
            petPersonalityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // 設置 petDetailedLabel 的約束
            petDetailedLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petDetailedLabel.topAnchor.constraint(equalTo: petPersonalityLabel.bottomAnchor, constant: 5),
//            petDetailedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // 設置 petPrecautionsLabel 的約束
            petPrecautionsLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 10),
            petPrecautionsLabel.topAnchor.constraint(equalTo: petDetailedLabel.bottomAnchor, constant: 5),
            petPrecautionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with pet: PetProtocol, images: [String: UIImage]) {
        petNameLabel.text = pet.name
        petBasicLabel.text = "\(pet.type), \(calculateAge(from: pet.birthDate)), \(pet.gender),  \(pet.size)"
        petPersonalityLabel.text = "\(pet.personality)"
        petDetailedLabel.text = "\(pet.neutered), \(pet.vaccinated)"
        petPrecautionsLabel.text = pet.precautions
        
        setPetImage(for: pet, in: images)
        
        petImageView.contentMode = .scaleAspectFill // 設置圖片內容模式
        petImageView.clipsToBounds = true // 裁剪圖片以適應圓形邊界
        petImageView.layer.cornerRadius = petImageView.frame.size.width / 2
    }
    
    func setPetImage(for pet: PetProtocol, in images: [String: UIImage]) {
        
        if let petImage = images[String(pet.petID!)] {
            petImageView.image = petImage
        } else {
            // 如果未找到圖像，您可以設置一個預設圖像或顯示空白圖像
            petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        }
    }

    
    private func calculateAge(from birthYear: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM" // 假設 pet.birthYear 的格式是 "yyyy-MM"
        
        if let petDate = dateFormatter.date(from: birthYear),
            let currentDate = dateFormatter.date(from: dateFormatter.string(from: Date())) {
            
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year, .month], from: petDate, to: currentDate)
            
            if let years = ageComponents.year, let months = ageComponents.month {
                    if years >= 1 {
                        if months == 0 {
                            return "\(years)歲"
                        }
                        return "\(years)歲又\(months)個月"
                    } else {
                        return "\(months)個月大"
                    }
                } else if let years = ageComponents.year {
                    return "\(years)歲"
            } else if let months = ageComponents.month {
                return "\(months)月大"
            }
        }
        return "年齡未知"
    }


}
