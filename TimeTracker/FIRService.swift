//
//  FIRService.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FIRService: FIRProtocol {
    
    //MARK: Properties
    
    static let sharedInstance : FIRService = {        
        let instance = FIRService()
        return instance
    }()
    
    //MARK: Fields
    
    var dbTaskRef: FIRDatabaseReference!
    var dbTaskSessionRef: FIRDatabaseReference!
    
    var dbTaskList: FIRDatabaseReference!
    var dbTaskSessionList: FIRDatabaseReference!
    var currentUser: User?
    
    //MARK: FIRProtocol
    
    func resolveCurrentlyLoggesUser() -> User?{
        
        setupUser(FIRAuth.auth()?.currentUser)
        return currentUser
    }
    
    func resolveAllTasks(_ completionHandler: @escaping (Error?, TaskCollection?) -> Void) {
        
        self.dbTaskList.observeSingleEvent(of: .value, with: {(snapshot) -> Void  in
            let taskCollection = TaskCollection(snapshot: snapshot)
            let taskList = taskCollection.taskList
            
            if !taskList.isEmpty {
                self.resolveActiveTaskSession({ (taskSession) in
                    self.setActiveTaskSession(taskSession: taskSession,
                                              for: taskCollection)
                    completionHandler(nil, taskCollection)
                })
            } else{
                completionHandler(nil, taskCollection)
            }
        })
    }
    
    func persistTask(taskToPersist: Task,
                     _ completionHandler: @escaping (Error?, TaskCollection?) -> Void){
        
        let taskChildDbRef = dbTaskList.child(taskToPersist.taskId)
        taskChildDbRef.setValue(taskToPersist.toAnyObject()) { (error, dbRef) in
            if let er = error {
                completionHandler(er, nil)
            } else {
                self.resolveAllTasks(completionHandler)
            }
        }
    }
    
    func login(login: String,
               password: String,
               _ completion: @escaping (FIRUser?, Error?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: login,
                               password: password,
                               completion: { (user, error) in
            self.setupUser(user)
            completion(user, error)
        })
    }
    
    func signUp(login: String,
                password: String,
                _ completion: @escaping (FIRUser?, Error?) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: login,
                                   password: password,
                                   completion: completion)
    }
    
    func startTask(taskToStartIndex: Int,
                   allTasks: [Task],
                   _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void){
        
        updateTasks(tasksToUpdate: allTasks)
        
        let taskToStart = allTasks[taskToStartIndex]
        let taskSessionToPersist = TaskSession(taskId: taskToStart.taskId,
                                               startTimestamp: String(NSDate().timeIntervalSince1970))
        
        taskToStart.startTime = Double(taskSessionToPersist.startTimestamp)
        
        let taskSessionChildDbRef = dbTaskSessionList.child(FIRConsts.activeTaskPath)
        taskSessionChildDbRef.setValue(taskSessionToPersist.toAnyObject(),
                                       withCompletionBlock: completionHandler)
    }
    
    func finishTask(taskToFinishIndex: Int,
                    allTasks: [Task],
                    _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void){
        
        updateTasks(tasksToUpdate: allTasks)
        let taskToFinish = allTasks[taskToFinishIndex]
        let taskSessionChildDbRef = dbTaskSessionList.child(FIRConsts.activeTaskPath)
        
        taskToFinish.startTime = nil
        
        taskSessionChildDbRef.observeSingleEvent(of: .value, with: {(snapshot) -> Void  in
            if !(snapshot.value is NSNull) {
                self.finishTaskSession(taskSessionSnapshot: snapshot,
                                       taskToFinish: taskToFinish, completionHandler)
            } else {
                let nsDict: NSDictionary = [NSLocalizedDescriptionKey: "Something went wrong."]
                let error = NSError(domain: "domain", code: 1, userInfo: nsDict as? [AnyHashable : Any])
                
                completionHandler(error, taskSessionChildDbRef)
            }
        })
    }
    
    func deleteTask(taskToDelete: Task){
        dbTaskList.child(taskToDelete.taskId).removeValue()
        dbTaskSessionList.child(FIRConsts.doneTaskPath).child(taskToDelete.taskId).removeValue()
    }
    
    //MARK: Functions
    
    func configure() {
        dbTaskRef = FIRDatabase.database().reference(withPath: FIRConsts.taskListPath)
        dbTaskSessionRef = FIRDatabase.database().reference(withPath: FIRConsts.taskSessionPath)
    }
    
    private func finishTaskSession(taskSessionSnapshot: FIRDataSnapshot,
                                   taskToFinish: Task,
                                   _ completionHandler: @escaping (Error?, FIRDatabaseReference) -> Void){
        
        let resolvedTaskSession = TaskSession(firSnapshot: taskSessionSnapshot)
        resolvedTaskSession.endTimestamp = String(NSDate().timeIntervalSince1970)

        let taskSessionDbRef = self.dbTaskSessionList.child(FIRConsts.doneTaskPath).child(taskToFinish.taskId).child(resolvedTaskSession.taskSessionId)

        DispatchQueue.main.async {
            taskSessionDbRef.setValue(resolvedTaskSession.toAnyObject(),
                                      withCompletionBlock: { (error, firDbReference) in
                if error is NSNull{
                    let taskSessionChildDbRef = self.dbTaskSessionList.child(FIRConsts.activeTaskPath)
                    taskSessionChildDbRef.removeValue()
                }
                
                completionHandler(error, firDbReference)
            })
        }
    }
    
    private func updateTasks(tasksToUpdate: [Task]){
        
        for task in tasksToUpdate {
            let taskChildDbRef = dbTaskList.child(task.taskId)
            taskChildDbRef.setValue(task.toAnyObject())
        }
    }
    
    private func setActiveTaskSession(taskSession: TaskSession?,
                                      for taskCollection: TaskCollection){
        
        if let session = taskSession {
            for index in 0..<taskCollection.taskList.count {
                let task = taskCollection.taskList[index]
                if task.taskId == session.taskId {
                    task.startTime = Double(session.startTimestamp)

                    taskCollection.activeTask = task
                    taskCollection.activeTaskIndex = index
                    return
                }
            }
        }
    }
    
    private func resolveActiveTaskSession(_ completion: @escaping (TaskSession?)->Void) {
        
        let taskSessionChildDbRef = dbTaskSessionList.child(FIRConsts.activeTaskPath)
        taskSessionChildDbRef.observeSingleEvent(of: .value, with: {(snapshot) -> Void  in
            
            var resolvedTaskSession: TaskSession?
            if snapshot.hasChildren() {
                resolvedTaskSession = TaskSession(firSnapshot: snapshot)
            }
            
            completion(resolvedTaskSession)
        })
    }
    
    private func setupUser(_ firUser: FIRUser?){
        
        if let user = firUser {
            currentUser = User(id: user.uid, email: user.email!)    
            
            dbTaskList = dbTaskRef.child((currentUser?.userId)!)
            dbTaskSessionList = dbTaskSessionRef.child((currentUser?.userId)!)
        }
    }
}
