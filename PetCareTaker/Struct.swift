//
//  Struct.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/16.
//

import Foundation


enum PetInfoSection: Int, CaseIterable {
    case image
    case name
    case description
    case basicInfo
    case detailedInfo
    
    var title: String {
        switch self {
        case .image:
            return ""
        case .name:
            return "寵物名稱"
        case .description:
            return "寵物介紹"
        case .basicInfo:
            return "基本資料"
        case .detailedInfo:
            return "詳細資料"
        }
    }
}

struct PetInfo {
    var name: String = ""
    var description: String = ""
    var type: String = ""
    var size: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var neutered: Bool = false
    var vaccinated: Bool = false
    var personality: String = ""
    var precautions: String = ""
}



struct PetTypes: Codable {
    var petType: [String: [String]]
}


struct Constraints {    // 圓角
    static let cornerRadious: CGFloat = 8.0
}

struct City: Codable {
    let name: String
    let districts: [District]
}

struct District: Codable {
    let zip: String
    let name: String
}

// 寵物結構
struct Pet: Codable {
    let petID: String
    var name: String
    var gender: String
    var type: String
    var birthDate: String
    var size: String
    var neutered: String
    var vaccinated: String
    var personality: String
    var photo: String
    var precautions: String
}

struct PetAndUserData: Encodable {
    let userID: String
    let petID: String
    var name: String
    var gender: String
    var type: String
    var birthDate: String
    var size: String
    var neutered: String
    var vaccinated: String
    var personality: String
    var photo: String
    var precautions: String
}

struct UserInfo: Codable {
    var phone: String
    var password: String
    var name: String
    var residenceArea: String
    
    enum CodingKeys: String, CodingKey {
        case phone = "Phone"
        case password = "Password"
        case name = "Name"
        case residenceArea = "ResidenceArea"
    }
}

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}
