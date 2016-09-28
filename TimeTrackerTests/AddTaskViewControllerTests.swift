//
//  AddTaskViewControllerTests.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 21.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
import FirebaseDatabase
import Firebase

@testable import TimeTracker

class AddTaskViewControllerTests: XCTestCase {
    
    //MARK: Fields
    
    var viewController: AddTaskViewController!
    let expectedDataSourceCount = 20
    let mockedText = "fake"
    
    //MARK: Setup
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        let _ = viewController.view
        
        cleanUpDB()
    }
    
    //MARK: Teardown
    
    override func tearDown() {
        super.tearDown()
        cleanUpDB()
    }
    
    //MARK: Tests
    
    func testTaskNameEditingChanged(){
        //assert
        XCTAssertTrue(!viewController.btnAddTask.isEnabled)
        
        //seetup
        viewController.textFieldTaskName.text = ""
        viewController.onTaskNameEditingChanged(viewController.textFieldTaskName)
        
        //assert
        XCTAssertTrue(!viewController.btnAddTask.isEnabled)
        
        //setup
        viewController.textFieldTaskName.text = mockedText
        viewController.onTaskNameEditingChanged(viewController.textFieldTaskName)
        
        //assert
        XCTAssertTrue(viewController.btnAddTask.isEnabled)
    }
    
    func testDidSelectItemAt(){
        //setup
        let selectedIndex = 3
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        viewController.collectionView(viewController.collectionView, didSelectItemAt: indexPath)
        
        //assert
        XCTAssertTrue(viewController.selectedIndex == selectedIndex)
        
        //setup
        let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: indexPath) as! AddTaskCellCollectionViewCell
        let isSelected = !cell.imgTick.isHidden
        
        //assert
        XCTAssertTrue(isSelected)
        
        //setup
        let selectedTaskModel = viewController.createdTask
        
        //assert
        XCTAssertTrue(selectedTaskModel.color == viewController.dataSource[selectedIndex])
        XCTAssertTrue(selectedTaskModel.name == viewController.textFieldTaskName.text)
    }
    
    func testCollectionDataList(){
        //setup
        let dataSourceList = viewController.getDataSourceList()
        
        //assert
        XCTAssertTrue(dataSourceList.count == expectedDataSourceCount)
    }
    
    func testNumberOfItemsInSection(){
        for _ in 0...20 {
            
            //setup
            let randomSectionNUmber = Int(arc4random_uniform(10))
            let result = viewController.collectionView(viewController.collectionView, numberOfItemsInSection: randomSectionNUmber)
            
            //assert
            XCTAssertTrue(result == expectedDataSourceCount)
        }
    }
    
    func testCellForItem(){
        for index in 0..<expectedDataSourceCount{
            //setup
            let indexPath = IndexPath(item: index, section: 0)
            
            let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: indexPath) as! AddTaskCellCollectionViewCell
            let bcgColor = cell.background.backgroundColor

            //assert
            XCTAssertTrue(bcgColor == viewController.dataSource[index])
        }
    }
    
    func testIfFirstElementIsSelected(){
        //setup
        let firstIndex = 0
        let indexPath = IndexPath(item: firstIndex, section: 0)
        
        let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: indexPath) as! AddTaskCellCollectionViewCell
        let isSelected = !cell.imgTick.isHidden
        
        //assert
        XCTAssertTrue(isSelected && viewController.selectedIndex == firstIndex)
    }
    
    //MARK: Helpers
    
    private func cleanUpDB(){
        let _ = FIRDatabase.database().reference().removeValue()
    }
}
