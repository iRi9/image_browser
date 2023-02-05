//
//  RelativeDateTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 05/02/23.
//

import XCTest
@testable import Image_Browser

final class RelativeDateTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_relative_date_now() {
        // given
        let date = Date()

        // when
        let relativeDate = RelativeDate.string(for: date)

        // result
        XCTAssertEqual(relativeDate, "now")
    }

    func test_relative_date_yesterday() {
        // Given
        let calendar = Calendar.current
        let todayDate = Date()
        let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: todayDate)!

        // When
        let relativeDate = RelativeDate.string(for: yesterdayDate)

        // Then
        XCTAssertEqual(relativeDate, "yesterday")
    }

    func test_relative_date_full_date() {
        // given
        let date = Date(timeIntervalSinceNow: -3600 * 24 * 3)

        // when
        let relativeDate = RelativeDate.string(for: date)

        // result
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let expectedDate = dateFormatter.string(from: date)
        XCTAssertEqual(relativeDate, expectedDate)
    }
}
