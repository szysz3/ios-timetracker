//
//  TimeFormatterTests.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 26.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
@testable import TimeTracker

class TimeFormatterTests: XCTestCase {
    
    //MARK: Test functions
    
    func testFormatTimespan() {
        
        //setup
        let expectedSecondsString = "0 seconds"
        let expectedMinutesString = "2 minutes  3 seconds"
        let expectedSecondsString2 = "59 seconds"
        let expectedHoursString = "1 hours  40 minutes"
        
        //assert
        XCTAssertEqual(TimeFormatter.formatTimespan(timespanToFormat: 0), expectedSecondsString)
        XCTAssertEqual(TimeFormatter.formatTimespan(timespanToFormat: 123), expectedMinutesString)
        XCTAssertEqual(TimeFormatter.formatTimespan(timespanToFormat: 59), expectedSecondsString2)
        XCTAssertEqual(TimeFormatter.formatTimespan(timespanToFormat: 6000), expectedHoursString)
    }
}
