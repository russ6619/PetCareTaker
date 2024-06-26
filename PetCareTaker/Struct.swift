//
//  Struct.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/16.
//

import Foundation
import UIKit


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
    var petID: Int? { get }
    var name: String { get }
    var type: String { get }
    var birthDate: String { get }
    var gender: String { get }
    var size: String { get }
    var personality: String { get }
    var neutered: String { get }
    var vaccinated: String { get }
    var photo: String? { get }
    var precautions: String { get }
}


// 寵物結構
struct Pet: PetProtocol, Codable {
    var petID: Int?
    var name: String
    var gender: String
    var type: String
    var birthDate: String
    var size: String
    var neutered: String
    var vaccinated: String
    var personality: String
    var photo: String?
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
    let userID: Int
    let petID: Int?
    var name: String
    var gender: String
    var type: String
    var birthDate: String
    var size: String
    var neutered: String
    var vaccinated: String
    var personality: String
    var photo: String?
    var precautions: String
}


struct UserRegisterInfo: Codable {
    var account: String
    var password: String
    var name: String
    var residenceArea: String
    
    enum CodingKeys: String, CodingKey {
        case account = "Account"
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
    let account: String
    let name: String
    let photo: String?
    let residenceArea: String
    let introduction: String
    let contact: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "Photo"
        case account = "Account"
        case name = "Name"
        case residenceArea = "ResidenceArea"
        case introduction = "Introduction"
        case contact = "Contact"
    }
}

struct PetData: PetProtocol, Codable {
    let petID: Int?
    let userID: Int
    let name: String
    let gender: String
    let type: String
    let birthDate: String
    let size: String
    let neutered: String
    let vaccinated: String
    let personality: String
    let photo: String?
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
    let style: UIAlertAction.Style // 新增樣式屬性

    init(title: String, style: UIAlertAction.Style, handler: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
