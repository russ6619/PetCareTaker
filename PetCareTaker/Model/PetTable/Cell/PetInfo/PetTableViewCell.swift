import UIKit

class PetTableViewCell: UITableViewCell {
    
    private var petImageView: UIImageView = {
        let image = UIImageView()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 在這裡添加視圖到 cell 中
        contentView.addSubview(petImageView)
        contentView.addSubview(petNameLabel)
        contentView.addSubview(petBasicLabel)
        contentView.addSubview(petPersonalityLabel)
        contentView.addSubview(petDetailedLabel)
        
        
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
            petDetailedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with pet: Pet) {
        
        // 在這裡設置視圖的內容
//        petImageView.image = UIImage(named: pet.photo)
        petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        petNameLabel.text = pet.name
        petBasicLabel.text = "\(pet.type), \(calculateAge(from: pet.birthDate)), \(pet.gender),  \(pet.size)"
        petPersonalityLabel.text = "\(pet.personality)"
        petDetailedLabel.text = "\(pet.neutered), \(pet.vaccinated)"
    }

    private func calculateAge(from birthYear: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM" // 假設 pet.birthYear 的格式是 "yyyy-MM"
        
        if let petDate = dateFormatter.date(from: birthYear),
            let currentDate = dateFormatter.date(from: dateFormatter.string(from: Date())) {
            
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year, .month], from: petDate, to: currentDate)
            
            if let years = ageComponents.year, let months = ageComponents.month {
                return "\(years)歲\(months)個月"
            } else if let years = ageComponents.year {
                return "\(years)歲"
            }
        }
        
        return "年齡未知"
    }


}
