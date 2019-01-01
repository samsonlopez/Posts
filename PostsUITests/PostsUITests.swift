//
//  PostsUITests.swift
//  PostsUITests
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import XCTest
@testable import Posts

class PostsUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    func test_PostsList_LoadsPostsSuccessfully() {
        let app = XCUIApplication()
        let cellCount = app.tables.cells.count
        XCTAssertEqual(cellCount, 100, "List count not 100 as expected")
    }

    func test_PostDetailSelection_NavigatesToCorrectPostDetail() {
        let app = XCUIApplication()
        let postsTable = app.tables.element(boundBy: 0)
        
        // Second cell text (post title) for Post List
        let secondCellElement = postsTable.cells.element(boundBy: 1).staticTexts.element(boundBy: 0)
        let secondCellElementTitleText = secondCellElement.label
        
        // Select second row to open post detail
        postsTable.cells.element(boundBy: 1).staticTexts.element(boundBy: 0).tap()

        let detailsTable = app.tables.element(boundBy: 1)

        // First cell text (post title) for Post Detail
        let firstCellElement = detailsTable.cells.element(boundBy: 0).staticTexts.element(boundBy: 0)
        let firstCellElementTitleText = firstCellElement.label
        
        // Check if title texts match
        XCTAssertEqual(secondCellElementTitleText, firstCellElementTitleText, "Correct post details not shown")
    }

}
