//
//  DatabaseManager.swift
//  MyInstagramApp
//
//  Created by iMac on 10.04.2021.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    //MARK: - Public
    //TODO: email representing email
    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        completion(true)
        
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, databaseRef in
            
            if error == nil {
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
    
}
