//
//  PasswordViewModel.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 15.08.24.
//

import Foundation
import KeychainAccess

final class PasswordViewModel {
    
    static var shared = PasswordViewModel()
    
    var isPassword: Bool = false
    
    let keychain = Keychain(service: "com.exercise.first.FileManager")
    
    func createPassword(password: String) {
        try? keychain.set(password, key: "FileManagerPassword")
        isPassword = true
    }
    
    func checkPassword(interedPassword: String) -> Bool {
        
        if let token = try? keychain.getString("FileManagerPassword"), interedPassword == token {
            return true
        } else {
            return false
        }
       
    }
    
    func getPassword() -> String? {
        if let token = try? keychain.getString("FileManagerPassword") {
            return token
        } else {
            return nil
        }
    }
}
