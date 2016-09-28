//
//  TaskService.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 24.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

class TaskService : TaskServiceProtocol {

    //MARK: Fields
    
    var taskServiceDelegate: TaskServiceDelegate
    var firService: FIRProtocol!
    var timer: Timer!
    
    //MARK: Inits
    
    init(delegate: TaskServiceDelegate, firService: FIRProtocol) {
        self.taskServiceDelegate = delegate
        self.firService = firService
    }
    
    //MARK: TaskServiceProtocol
    
    func handleTaskTouched(touchedTaskIndex: Int) {
        stopTimer()
        
        let selectedTask = taskServiceDelegate.getTask(taskIndex: touchedTaskIndex)
        selectedTask.requestInProgress = true
        
        taskServiceDelegate.reloadData()
        
        let isSelectedTaskRunning = selectedTask.isRunning
        for task in taskServiceDelegate.getAllTasks() {
            task.isEnabled = isSelectedTaskRunning
            task.isRunning = false
        }
        
        selectedTask.isRunning = !isSelectedTaskRunning
        selectedTask.isEnabled = true
        
        if !isSelectedTaskRunning {
            firService.startTask(taskToStartIndex: touchedTaskIndex,
                                 allTasks: taskServiceDelegate.getAllTasks(), { (error, firDbRef) in
                self.handleFirCallback(error,
                                       selectedItemIndex: touchedTaskIndex,
                                       isSelectedTaskRunning: isSelectedTaskRunning)
                guard let _ = error
                    else {
                        self.startTimerForTask(taskIndex: touchedTaskIndex)
                        return
                }
            })
        } else{
            firService.finishTask(taskToFinishIndex: touchedTaskIndex,
                                  allTasks: taskServiceDelegate.getAllTasks(), { (error, firDbRef) in
                self.handleFirCallback(error,
                                       selectedItemIndex: touchedTaskIndex,
                                       isSelectedTaskRunning: isSelectedTaskRunning)
            })
        }
    }
    
    func initializeTasks() {
        taskServiceDelegate.manageOverlay(showOverlay: true)
        
        firService.resolveAllTasks { (error, taskCollection) in
            if let er = error {
                self.taskServiceDelegate.showAlert(title: UIConsts.alertTitle,
                                                   message: er.localizedDescription,
                                                   btn: UIConsts.alertBtnTitle)
            } else {
                self.handleTasks(taskCollection: taskCollection)
            }
            
            self.taskServiceDelegate.manageOverlay(showOverlay: false)
        }
    }
    
    func persistTask(taskToPersist: Task) {
        firService.persistTask(taskToPersist: taskToPersist) { (error, taskCollection) in
            if let er = error {
                self.taskServiceDelegate.showAlert(title: UIConsts.alertTitle,
                                                   message: er.localizedDescription,
                                                   btn: UIConsts.alertBtnTitle)
            } else {
                self.handleTasks(taskCollection: taskCollection)
            }
        }
    }
    
    //MARK: Functions
    
    private func handleTasks(taskCollection: TaskCollection!){
        if let tasks = taskCollection {
            self.taskServiceDelegate.setTaskList(newTaskList: tasks.taskList)

            if let activeTaskPosition = taskCollection?.activeTaskIndex {
                startTimerForTask(taskIndex: activeTaskPosition)
            }
            self.taskServiceDelegate.reloadData()
        }
    }
    
    private func startTimerForTask(taskIndex: Int){
        stopTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: self.taskServiceDelegate.refreshTimeInterval,
                                          repeats: true,
                                          block: { (timer) in
                                                let indexPath = IndexPath(item: taskIndex, section: 0)
                                                self.taskServiceDelegate.reloadData(forRows: [indexPath]) })
    }
    
    private func stopTimer(){
        if let t = timer {
            t.invalidate()
        }
        timer = nil
    }
    
    private func handleFirCallback(_ error: Error?, selectedItemIndex: Int, isSelectedTaskRunning: Bool){
        if let err = error {
            self.taskServiceDelegate.showAlert(title: UIConsts.alertTitle,
                                               message: err.localizedDescription,
                                               btn: UIConsts.alertBtnTitle)
        }
        
        let task = taskServiceDelegate.getTask(taskIndex: selectedItemIndex)
        task.requestInProgress = false
        
        taskServiceDelegate.reloadData()
    }
}
