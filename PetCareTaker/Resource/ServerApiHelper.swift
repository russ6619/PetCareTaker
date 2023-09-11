//
//  ServerApiHelper.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/26.
//

import Foundation

class ServerApiHelper {
    static let shared = ServerApiHelper() 

    let apiUrlString: String
    
    let loginUserUrl: String
    let registerUserUrl: String
    let queryUserUrl: String
    let updateUserUrl: String
    
    let createPetUrl: String
    let deletePetUrl: String
    let queryPetUrl: String
    let updatePetUrl: String

    private init() {
        apiUrlString = "http://localhost:8888/PetCareTakerServer/"
        loginUserUrl = apiUrlString + "User/loginUser.php"
        registerUserUrl = apiUrlString + "User/registerUser.php"
        queryUserUrl = apiUrlString + "User/queryUser.php"
        updateUserUrl = apiUrlString + "User/updateUser.php"
        
        createPetUrl = apiUrlString + "UserPet/createPet.php"
        deletePetUrl = apiUrlString + "UserPet/deletePet.php"
        queryPetUrl = apiUrlString + "UserPet/queryPet.php"
        updatePetUrl = apiUrlString + "UserPet/updatePet.php"
    }
}

