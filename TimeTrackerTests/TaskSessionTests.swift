//
//  TaskSessionTests.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 26.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
import FirebaseDatabase

@testable import TimeTracker

class TaskSessionTests : XCTestCase {
    
    //MARK: Fields
    
    let mockedTaskId1 = "mockedTaskId"
    let mockedTimestamp1 = "1234"
    
    let mockedTaskId2 = "mockedTaskId2"
    let mockedTimestamp2 = "12345"
    
    //MARK: Test functions
    
    func testTaskSessionEquality() {
        
        //setup
        let taskSession = TaskSession(taskId: mockedTaskId1, startTimestamp: mockedTimestamp1)
        let onotherTaskSession = TaskSession(taskId: mockedTaskId2, startTimestamp: mockedTimestamp2)
        
        //assert
        XCTAssertFalse(taskSession == onotherTaskSession)
        XCTAssertTrue(taskSession == taskSession)
    }
}
