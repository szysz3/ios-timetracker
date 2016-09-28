//
//  TaskServiceProtocol.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 24.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
protocol TaskServiceProtocol {
    
    //MARK: Functions
    
    func persistTask(taskToPersist: Task)
    func initializeTasks()
    func handleTaskTouched(touchedTaskIndex: Int)
}
