//
//  TaskServiceProtocol.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 24.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

protocol TaskServiceDelegate {
    
    //MARK: Fields
    
    var refreshTimeInterval: TimeInterval! { get }
    
    //MARK: Functions
    
    func reloadData()
    func reloadData(forRows: [IndexPath])
    
    func getAllTasks() -> [Task]
    func getTask(taskIndex: Int) -> Task
    func setTaskList(newTaskList: [Task])
    
    func manageOverlay(showOverlay: Bool)
    func showAlert(title: String, message: String, btn: String)
}
