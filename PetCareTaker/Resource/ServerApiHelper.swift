//
//  ServerApiHelper.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/26.
//

import Foundation

class ServerApiHelper {
    static let shared = ServerApiHelper()
    
    let privacyUrl: String
    let apiUrlString: String
    
    let imageUrlString: String
    let updatePhotoUrl: String
    
    // User
    let loginUserUrl: String
    let registerUserUrl: String
    let queryUserUrl: String
    let updateUserUrl: String
    let deleteUserUrl: String
    // UserPets
    let createPetUrl: String
    let deletePetUrl: String
    let queryPetUrl: String
    let updatePetUrl: String
    let renamePetPhoto: String
    // Tasks
    let createTasksUrl: String
    let deleteTasksUrl: String
    let queryTasksUrl: String
    let updateTaskUrl: String
    let queryPublisherInfoUrl: String
    let queryTasksFromUserIDUrl: String
    

    private init() {
        
        privacyUrl = "https://www.privacypolicies.com/live/d422da17-addb-445b-8912-9e3ab9b01653"
        // 測試
//        apiUrlString = "http://172.233.90.79/PetCareTakerServer/"
        
        // 連線
        apiUrlString = "http://172.233.90.79/PetCareTakerServer3/"
        
        imageUrlString = apiUrlString + "uploads/"
        updatePhotoUrl = apiUrlString + "updatePhoto.php"
        
        // User
        loginUserUrl = apiUrlString + "User/loginUser.php"
        registerUserUrl = apiUrlString + "User/registerUser.php"
        queryUserUrl = apiUrlString + "User/queryUser.php"
        updateUserUrl = apiUrlString + "User/updateUser.php"
        deleteUserUrl = apiUrlString + "User/deleteUser.php"
        
        // UserPets
        createPetUrl = apiUrlString + "UserPet/createPet.php"
        deletePetUrl = apiUrlString + "UserPet/deletePet.php"
        queryPetUrl = apiUrlString + "UserPet/queryPet.php"
        updatePetUrl = apiUrlString + "UserPet/updatePet.php"
        
        renamePetPhoto = apiUrlString + "renamePetPhoto.php"
        
        // Tasks
        createTasksUrl = apiUrlString + "Tasks/createTasks.php"
        deleteTasksUrl = apiUrlString + "Tasks/deleteTasks.php"
        queryTasksUrl = apiUrlString + "Tasks/queryTasks.php"
        updateTaskUrl = apiUrlString + "Tasks/updateTasks.php"
        queryTasksFromUserIDUrl = apiUrlString + "Tasks/queryTasksFromUserID.php"
        queryPublisherInfoUrl = apiUrlString + "Tasks/queryPublisherInfo.php"
    }
}

