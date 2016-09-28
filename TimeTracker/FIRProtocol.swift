//
//  FIRProtocol.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import  FirebaseAuth
import FirebaseDatabase

protocol FIRProtocol {
    
    //MARK: Properties
    
    var currentUser: User? { get }
    
    //MARK: Functions
    
    func resolveCurrentlyLoggesUser() -> User?
    func deleteTask(taskToDelete: Task)
    func login(login: String, password: String, _ completion: @escaping(FIRUser?, Error?) -> Void)
    func signUp(login: String, password: String, _ completion: @escaping(FIRUser?, Error?) -> Void)
    func startTask(taskToStartIndex: Int, allTasks: [Task], _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void)
    func finishTask(taskToFinishIndex: Int, allTasks: [Task], _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void)
    func persistTask(taskToPersist: Task, _ completionHandler: @escaping (Error?, TaskCollection?) -> Void)
    func resolveAllTasks(_ completionHandler: @escaping (Error?, TaskCollection?) -> Void)
}
