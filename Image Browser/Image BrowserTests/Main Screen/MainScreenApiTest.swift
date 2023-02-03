//
//  MainScreenApiTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 02/02/23.
//

import XCTest
@testable import Image_Browser

final class MainScreenApiTest: XCTestCase {

    var sut: ImageListApi!

    override func setUp() {
        super.setUp()
        sut = ImageListApi()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_imageList() {
        // given
        let expect = XCTestExpectation(description: "callback")
        let limit = 30

        // when
        sut.fetch(page: 1, limit: limit) { status, imageList, error in
            expect.fulfill()
            // result
            XCTAssertEqual(imageList.count, limit)
            let _ = imageList.map { img in
                XCTAssertNotNil(img.id)
            }
        }
        wait(for: [expect], timeout: 3.1)
    }

}
