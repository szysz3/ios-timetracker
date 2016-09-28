//
//  TaskListViewControllerTest.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 21.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
import FirebaseDatabase

@testable import TimeTracker

class TaskListViewControllerTest: XCTestCase {
    
    //MARK: Fields
    
    var viewController: TaskListViewController!
    var firServiceMock: FIRServiceMock!
    
    let mockedTaskName = "fake task name"
    let expectedMessage = "Something went wrong."
    let expectedTitle = "Oops!"
    let expectedBtnTitle = "OK"
    let requestTimeout: TimeInterval = 5
    
    //MARK: Setup
    
    override func setUp() {
        super.setUp()
        cleanUpDB()
    }
    
    //MARK: Teardown
    
    override func tearDown() {
        super.tearDown()
        cleanUpDB()
    }
    
    //MARK: Tests
    
    func testCanEditRowAt(){
        //setup
        setupTest()
        
        let taskServiceDelegate = self.viewController as TaskServiceDelegate
        let indexPath = IndexPath(item: 0, section: 0)
        let task = Task(taskName: mockedTaskName, backgroundColor: UIColor.red)
        
        task.isRunning = true
        
        let taskList = [task]
        taskServiceDelegate.setTaskList(newTaskList: taskList)

        let canEditRowAtIndex = viewController.tableView(viewController.tableView, canEditRowAt: indexPath)
        let isItemRunning = viewController.getTask(taskIndex: indexPath.row).isRunning
        
        //assert
        XCTAssertTrue(canEditRowAtIndex != isItemRunning)
        
        //setup
        task.isRunning = false
        
        //assert
        XCTAssertTrue(canEditRowAtIndex != isItemRunning)
    }
    
    func testInitializationWithError(){
        
        //setup
        firServiceMock = FIRServiceMock()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
        
        firServiceMock.resolveAllTasksClosure = resolveAllTasksMockWithError
        let taskService = TaskService(delegate: viewController, firService: firServiceMock)
        
        viewController.taskService = taskService
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
        let _ = viewController.view
        
        let promise = expectation(description: "initialization error")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeout) {
            let alertControler = self.viewController.presentedViewController as! UIAlertController
            
            //assert
            XCTAssertNotNil(alertControler)
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeout * 2, handler: nil)
    }
    
    func testInitialization(){
        
        //setup
        firServiceMock = FIRServiceMock()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
        
        firServiceMock.resolveAllTasksClosure = resolveAllTasksMock
        let taskService = TaskService(delegate: viewController, firService: firServiceMock)
        
        viewController.taskService = taskService
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
        let _ = viewController.view
        
        let promise = expectation(description: "initialization")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeout) {
            
            //assert
            XCTAssertNotNil(self.viewController.getAllTasks())
            XCTAssertTrue(self.viewController.getAllTasks().count == 1)
            XCTAssertTrue(self.viewController.getTask(taskIndex: 0).name == "mockedName")
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeout * 2, handler: nil)
    }
    
    func testDidSelectRowAt(){
        
        //setup
        setupTest()
        
        let taskServiceDelegate = self.viewController as TaskServiceDelegate
        let indexPath = IndexPath(item: 0, section: 0)
        let taskList = [Task(taskName: mockedTaskName, backgroundColor: UIColor.red)]
        
        taskServiceDelegate.setTaskList(newTaskList: taskList)
        viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)
        
        let didSelectPromise = expectation(description: "did select row")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeout) {
            let cell = self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) as! TaskCell
            
            //assert
            XCTAssertTrue(cell.isUserInteractionEnabled)
            XCTAssertTrue(cell.lblDuration.text != "")
            XCTAssertTrue(cell.overlay.isHidden)
            
            let taskModel = taskServiceDelegate.getTask(taskIndex: indexPath.row)
            
            //assert
            XCTAssertTrue(taskModel.isRunning)
            XCTAssertTrue(taskModel.isEnabled)
            XCTAssertTrue(taskModel.startTime! > 0)
            
            didSelectPromise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeout * 2, handler: nil)
        
        //setup
        viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)
        let didSelectAgainPromise = expectation(description: "did select again row")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeout) {
            let cell = self.viewController.tableView(self.viewController.tableView, cellForRowAt: indexPath) as! TaskCell
            
            //assert
            XCTAssertTrue(cell.isUserInteractionEnabled)
            XCTAssertTrue(cell.lblDuration.text == "")
            XCTAssertTrue(cell.overlay.isHidden)
            
            let taskModel = taskServiceDelegate.getTask(taskIndex: indexPath.row)
            
            //assert
            XCTAssertFalse(taskModel.isRunning)
            XCTAssertTrue(taskModel.isEnabled)
            XCTAssertNil(taskModel.startTime)
            
            didSelectAgainPromise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeout * 2, handler: nil)
    }
    
    func testNumberRowsInSection(){
        //setup
        setupTest()
        
        let taskServiceDelegate = viewController as TaskServiceDelegate
        let taskList = [Task(taskName: mockedTaskName, backgroundColor: UIColor.red)]
        
        //assert
        XCTAssertTrue(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0) == 0)
        
        //setup
        taskServiceDelegate.setTaskList(newTaskList: taskList)
        
        //assert
        XCTAssertTrue(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0) == 1)
    }
    
    func testDataSource(){
        //setup
        setupTest()
        
        let taskServiceDelegate = viewController as TaskServiceDelegate
        let taskList = [Task(taskName: mockedTaskName, backgroundColor: UIColor.red)]
        
        taskServiceDelegate.setTaskList(newTaskList: taskList)
        
        //assert
        XCTAssertNotNil(taskServiceDelegate.getAllTasks())
        XCTAssertTrue(taskList.count == taskServiceDelegate.getAllTasks().count)
        XCTAssertTrue(taskList[0] == taskServiceDelegate.getTask(taskIndex: 0))
    }
    
    func testRefreshtimeInterval(){
        //setup
        setupTest()
        let taskServiceDelegate = viewController as TaskServiceDelegate
        
        //assert
        XCTAssertTrue(taskServiceDelegate.refreshTimeInterval == 1)
    }
    
    func testBackToTaskListAfterAddition(){
        //setup
        setupTest()
        
        let addTaskViewController = initializeAddTaskVC()
        addTaskViewController.textFieldTaskName.text = mockedTaskName
        
        let segue = UIStoryboardSegue(identifier: "testSegue", source: addTaskViewController, destination: viewController)
        viewController.backToTaskListAfterAddition(segue: segue)
        
        let promise = expectation(description: "resolved tasks")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeout) { 
            let resolvedTasks = self.viewController.getAllTasks()
            
            //assert
            XCTAssertTrue(resolvedTasks.count == 1)
            XCTAssertTrue(resolvedTasks[0] == addTaskViewController.createdTask)
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeout * 2, handler: nil)
    }
    
    func testBackToTaskListAfterAdditionWithFailure(){
        //setup
        setupTest()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
        
        viewController.firService = FIRServiceMock()
        UIApplication.shared.keyWindow?.rootViewController = viewController
        let _ = viewController.view
        
        let addTaskViewController = initializeAddTaskVC()
        addTaskViewController.textFieldTaskName.text = mockedTaskName
        
        let segue = UIStoryboardSegue(identifier: "testSegue", source: addTaskViewController, destination: viewController)
        
        viewController.backToTaskListAfterAddition(segue: segue)
        
        let promise = expectation(description: "resolved tasks")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeout) {

            let alertControler = self.viewController.presentedViewController as! UIAlertController
            
            //assert
            XCTAssertNotNil(alertControler)
            XCTAssertTrue(alertControler.title == self.expectedTitle)
            XCTAssertTrue(alertControler.message == self.expectedMessage)
            XCTAssertTrue(alertControler.actions.count == 1)
            XCTAssertTrue(alertControler.actions[0].title == self.expectedBtnTitle)
            XCTAssertTrue(alertControler.actions[0].style == UIAlertActionStyle.cancel)
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeout * 2, handler: nil)
    }
    
    func testBackToTaskListAfterCancel(){
        //setuo
        setupTest()
        
        let addTaskViewController = initializeAddTaskVC()
        let segue = UIStoryboardSegue(identifier: "testBackSegue", source: addTaskViewController, destination: viewController)
        
        viewController.backToTaskListAfterCancel(segue: segue)
        
        //assert
        XCTAssertNil(viewController.presentedViewController)
    }
    
    //MARK: Helpers
    
    private func initializeAddTaskVC() -> AddTaskViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let addTaskViewController = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as!AddTaskViewController
        let _ = addTaskViewController.view
        
        return addTaskViewController
    }
    
    private func resolveAllTasksMockWithError(handler: (Error?, TaskCollection?) -> Void){
        let nsDict: NSDictionary = [NSLocalizedDescriptionKey: "Something went wrong."]
        let error = NSError(domain: "domain", code: 1, userInfo: nsDict as? [AnyHashable : Any])
        
        handler(error, TaskCollection(taskList: []))
    }
    
    private func resolveAllTasksMock(handler: (Error?, TaskCollection?) -> Void){
        let task = Task(taskName: "mockedName", backgroundColor: UIColor.red)
        
        handler(nil, TaskCollection(taskList: [task]))
    }
    
    private func cleanUpDB(){
        let _ = FIRDatabase.database().reference().removeValue()
    }
    
    private func setupTest(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        let _ = viewController.view
    }
}
