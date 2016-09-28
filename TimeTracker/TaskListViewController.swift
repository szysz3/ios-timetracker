//
//  FirstViewController.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 18.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TaskListViewController: UIViewController, UITableViewDelegate,
                                UITableViewDataSource, TaskServiceDelegate {

    //MARK: Outlets & Actions
    
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressOverlay: UIView!
    @IBOutlet weak var navBar: UIView!
    
    @IBAction func backToTaskListAfterCancel(segue:UIStoryboardSegue) {
        //intentionally left blank
    }
    
    @IBAction func backToTaskListAfterAddition(segue:UIStoryboardSegue) {
        let sourceVC = segue.source as! AddTaskViewController
        let selectedTask = sourceVC.createdTask
        
        taskService.persistTask(taskToPersist: selectedTask)
    }
    
    //MARK: Fields & Properties
    
    private var taskCollection: TaskCollection = TaskCollection(taskList: [])
    private var timerInterval: TimeInterval = 1
    private var taskServiceInstance: TaskService!
    var firService: FIRProtocol = FIRService.sharedInstance
    
    var taskService: TaskService! {
        get{
            if self.taskServiceInstance == nil {
                taskServiceInstance = TaskService(delegate: self, firService: self.firService)
            }
            
            return taskServiceInstance
        }
        set(value){
            taskServiceInstance = value
        }
    }
    
    var refreshTimeInterval: TimeInterval! {
        get {
            return timerInterval
        }
    }
    
    //MARK: TaskServiceDelegate
    
    func setTaskList(newTaskList: [Task]) {
        taskCollection.taskList = newTaskList
    }
    
    func getTask(taskIndex: Int) -> Task {
        return taskCollection.taskList[taskIndex]
    }
    
    func getAllTasks() -> [Task] {
        return taskCollection.taskList
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    func reloadData(forRows: [IndexPath]){
        tableView.reloadRows(at: forRows, with: .none)
    }
    
    func manageOverlay(showOverlay: Bool) {
        return progressOverlay.isHidden = !showOverlay
    }
    
    func showAlert(title: String, message: String, btn: String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: btn, style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        initTableView()
        
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskService.initializeTasks()
    }
    
    func initialize(){
        navBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navBar.layer.shadowColor = UIColor.gray.cgColor
        navBar.layer.shadowRadius = 2
        navBar.layer.shadowOpacity = 0.8
    }
    
    func initTableView(){
        tableView.register(UINib(nibName: TaskCell.tag, bundle: nil), forCellReuseIdentifier: TaskCell.tag)
    }
    
    func hideNavigationBar(){
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let taskModel = taskCollection.taskList[indexPath.row]
        return !taskModel.isRunning
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskService.handleTaskTouched(touchedTaskIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "delete") { (rowAction, indexPath) in
            
            let taskToDelete = self.taskCollection.taskList[indexPath.row]
            self.firService.deleteTask(taskToDelete: taskToDelete)
            self.taskCollection.taskList.remove(at: indexPath.row)
            
            var indexSet: [IndexPath] = []
            for index in indexPath.row..<self.taskCollection.taskList.count {
                indexSet.append(IndexPath(item: index, section: 0))
            }
            
            tableView.reloadData()
            tableView.reloadRows(at: indexSet, with: UITableViewRowAnimation.fade)
        }
        
        deleteAction.backgroundColor = UIColor.darkGray
        return [deleteAction]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: TaskCell.tag, for: indexPath) as! TaskCell
        
        let index = indexPath.row
        let task = taskCollection.taskList[index]
        
        taskCell.imgColor.backgroundColor = task.color
        taskCell.lblTitle.text = task.name
        
        taskCell.activityIndicatorOverlay.isHidden = !task.requestInProgress
        taskCell.activityInidcator.startAnimating()
        taskCell.overlay.isHidden = task.isEnabled
        taskCell.isUserInteractionEnabled = task.isEnabled
        taskCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let taskStartTime = task.startTime {
            let duration = TimeFormatter.formatTimespan(timespanToFormat: NSDate().timeIntervalSince1970 - taskStartTime)
            taskCell.lblDuration.text = duration
        } else {
            taskCell.lblDuration.text = ""
        }
        
        return taskCell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCollection.taskList.count
    }
}

