//
//  DukeEventCalendarTests.swift
//  DukeEventCalendarTests
//
//  Created by xz353 on 10/29/23.
//

import XCTest

@testable import DukeEventCalendar

final class DukeEventCalendarTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let bundle = Bundle(for: DukeEventCalendarTests.self)
        let url = bundle.bundleURL.appendingPathComponent("sample_90.json")
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let events = try decoder.decode([String: [Event]].self, from: data)
        let firstEvent = events["events"]!.first
        XCTAssertEqual(
            firstEvent?.image,
            URL(
                string:
                    "https://calendar.duke.edu/images//2023/20231001/e803641db77b22df79fb6aa807689c32-CR-PARK CHURCH (530 x 353 px)_20211025051033PM.png"
            )
        )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
