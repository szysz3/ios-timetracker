//
//  TaskCollection.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 24.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TaskCollection {
    
    //MARK: Fields
    
    var taskList: [Task]
    var activeTask: Task?
    var activeTaskIndex: Int?
    
    //MARK: Inits
    
    init(snapshot: FIRDataSnapshot!) {
        taskList = []
        if !(snapshot.value is NSNull) {
            
            for item in snapshot.children{
                let itemSnapshot = item as! FIRDataSnapshot
                taskList.append(Task(firSnapshot: itemSnapshot))
            }
        }
    }
    
    init(taskList: [Task]) {
        self.taskList = taskList
    }
}
