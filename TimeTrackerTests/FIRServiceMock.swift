//
//  FIRServiceMock.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
@testable import TimeTracker

class FIRServiceMock: FIRProtocol{

    var currentUser: User?
    
    var resolveCurrentlyLoggesUserClosure: (() -> User?)?
    var resolveAllTasksClosure: (((Error?, TaskCollection?) -> Void) -> Void)?
    
    func addTaskListObserver(snapshotCompletion: @escaping (FIRDataSnapshot) -> Void){
        //stub
    }
    
    func resolveCurrentlyLoggesUser() -> User? {
        return self.resolveCurrentlyLoggesUserClosure!()
    }
    
    func login(login: String, password: String, _ completion: @escaping(FIRUser?, Error?) -> Void) {
        //stub
    }
    
    func signUp(login: String, password: String, _ completion: @escaping(FIRUser?, Error?) -> Void) {
        //stub
    }
    
    func startTask(taskToStartIndex: Int, allTasks: [Task], _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void){
        //stub
    }
    
    func finishTask(taskToFinishIndex: Int, allTasks: [Task], _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void){
       //stub
    }
    
    func getActiveTaskSession(completion: @escaping (TaskSession?)->Void) {
        //stub
    }
    
    func persistTask(taskToPersist: Task, _ completionHandler: @escaping (Error?, TaskCollection?) -> Void){
        let nsDict: NSDictionary = [NSLocalizedDescriptionKey: "Something went wrong."]
        let error = NSError(domain: "domain", code: 1, userInfo: nsDict as? [AnyHashable : Any])
        
        completionHandler(error, TaskCollection(taskList: []))
    }
    
    func resolveAllTasks(_ completionHandler: @escaping (Error?, TaskCollection?) -> Void){
        let closure: (Error?, TaskCollection?) -> Void = { (error, collection) in
            completionHandler(error, collection)
        }
        
        if let resolveClosure = resolveAllTasksClosure{
            resolveClosure(closure)
        }
    }
    
    func deleteTask(taskToDelete: Task){
        //stub
    }
}
