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

protocol PetProtocol {
    var petID: String { get }
    var name: String { get }
    var type: String { get }
    var birthDate: String { get }
    var gender: String { get }
    var size: String { get }
    var personality: String { get }
    var neutered: String { get }
    var vaccinated: String { get }
    var photo: String { get }
    var precautions: String { get }
}


// 寵物結構
struct Pet: PetProtocol, Codable {
    var petID: String
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

struct Tasks: Codable {
    let TaskID: String
    let PublisherID: String
    let TaskName: String
    let TaskInfo: String
    let StartDate: String
    let EndDate: String
    let TaskReward: String
    let TaskDeadline: String
    let TaskStatus: String
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

//struct UserInfo: Codable {
//    var phone: String
//    var password: String
//    var name: String
//    var residenceArea: String
//    var introduction: String
//    
//    enum CodingKeys: String, CodingKey {
//        case phone = "Phone"
//        case password = "Password"
//        case name = "Name"
//        case residenceArea = "ResidenceArea"
//        case introduction = "Introduction"
//    }
//}

struct UserRegisterInfo: Codable {
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

struct UserDataResponse: Codable {
    let userData: UserData
    let petsData: [PetData]
}

struct UserData: Codable {
    let phone: String
    let name: String
    let photo: String
    let residenceArea: String
    let introduction: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "Photo"
        case phone = "Phone"
        case name = "Name"
        case residenceArea = "ResidenceArea"
        case introduction = "Introduction"
    }
}

struct PetData: PetProtocol, Codable {
    let petID: String
    let userID: String
    let name: String
    let gender: String
    let type: String
    let birthDate: String
    let size: String
    let neutered: String
    let vaccinated: String
    let personality: String
    let photo: String
    let precautions: String
    
    enum CodingKeys: String, CodingKey {
        case petID = "PetID"
        case userID = "UserID"
        case name = "Name"
        case gender = "Gender"
        case type = "Type"
        case birthDate = "BirthDate"
        case size = "Size"
        case neutered = "Neutered"
        case vaccinated = "Vaccinated"
        case personality = "Personality"
        case photo = "Photo"
        case precautions = "Precautions"
    }
}




struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}
