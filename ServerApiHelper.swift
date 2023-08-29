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
    let registerUserURL: String

    private init() {
        apiUrlString = "http://localhost:8888/PetCareTakerServer/"
        loginUserUrl = apiUrlString + "loginUser.php"
        registerUserURL = apiUrlString + "registerUser.php"
    }
    
    
}
