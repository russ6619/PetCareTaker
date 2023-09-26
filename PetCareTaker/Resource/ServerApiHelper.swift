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
    
    let imageUrlString: String
    let updatePhotoUrl: String
    
    // User
    let loginUserUrl: String
    let registerUserUrl: String
    let queryUserUrl: String
    let updateUserUrl: String
    // UserPets
    let createPetUrl: String
    let deletePetUrl: String
    let queryPetUrl: String
    let updatePetUrl: String
    // Tasks
    let createTasksUrl: String
    let deleteTasksUrl: String
    let queryTasksUrl: String
    let updateTaskUrl: String
    let queryPublisherPhoneUrl: String
    let queryTasksFromUserIDUrl: String

    private init() {
        // 測試
        apiUrlString = "http://localhost:8888/PetCareTakerServer/"
        
        // 連線
//        apiUrlString = "https://repo.serveo.net/PetCareTakerServer/"
        
        imageUrlString = apiUrlString + "uploads/"
        updatePhotoUrl = apiUrlString + "updatePhoto.php"
        
        // User
        loginUserUrl = apiUrlString + "User/loginUser.php"
        registerUserUrl = apiUrlString + "User/registerUser.php"
        queryUserUrl = apiUrlString + "User/queryUser.php"
        updateUserUrl = apiUrlString + "User/updateUser.php"
        
        // UserPets
        createPetUrl = apiUrlString + "UserPet/createPet.php"
        deletePetUrl = apiUrlString + "UserPet/deletePet.php"
        queryPetUrl = apiUrlString + "UserPet/queryPet.php"
        updatePetUrl = apiUrlString + "UserPet/updatePet.php"
        
        // Tasks
        createTasksUrl = apiUrlString + "Tasks/createTasks.php"
        deleteTasksUrl = apiUrlString + "Tasks/deleteTasks.php"
        queryTasksUrl = apiUrlString + "Tasks/queryTasks.php"
        updateTaskUrl = apiUrlString + "Tasks/updateTasks.php"
        queryTasksFromUserIDUrl = apiUrlString + "Tasks/queryTasksFromUserID.php"
        queryPublisherPhoneUrl = apiUrlString + "Tasks/queryPublisherPhone.php"
    }
}

