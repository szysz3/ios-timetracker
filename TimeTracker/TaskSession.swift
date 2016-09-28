//
//  TaskSession.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 23.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TaskSession : Equatable {
    
    //MARK: Fields
    
    var taskSessionId: String
    var taskId: String
    var startTimestamp: String
    
    var endTimestamp: String!
    
    //MARK: Inits
    
    init(taskId: String, startTimestamp: String) {
        self.taskId = taskId
        self.startTimestamp = startTimestamp
        
        taskSessionId = NSUUID().uuidString
        endTimestamp = ""
    }
    
    init(firSnapshot: FIRDataSnapshot) {
        var snapshot = firSnapshot.value! as! [String:AnyObject]
        
        taskSessionId = snapshot["taskSessionId"] as! String
        taskId = snapshot["taskId"] as! String
        startTimestamp = snapshot["startTimestamp"] as! String
        endTimestamp = snapshot["endTimestamp"] as! String
    }
    
    //MARK: Functions
    
    func toAnyObject() -> AnyObject {
        let anyObject = [
            "taskSessionId" : taskSessionId as AnyObject,
            "taskId" : taskId as AnyObject,
            "startTimestamp" : startTimestamp as AnyObject,
            "endTimestamp" : endTimestamp as AnyObject
            ] as [String : AnyObject]
        
        return anyObject as AnyObject
    }
    
    public static func ==(lhs: TaskSession, rhs: TaskSession) -> Bool {
        return lhs.taskId == rhs.taskId && lhs.taskSessionId == rhs.taskSessionId && lhs.startTimestamp == rhs.startTimestamp && lhs.endTimestamp == rhs.endTimestamp
    }
}
