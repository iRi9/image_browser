//
//  CommentGeneratorResourceTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 04/02/23.
//

import XCTest
@testable import Image_Browser

final class CommentGeneratorResourceTest: XCTestCase {
    var sut: CommentGenerator!

    override func setUp() {
        super.setUp()
        sut = CommentGenerator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_generate_comment_text() {
        // given
        var comment = ""

        // when
        comment = sut.generateText()

        // result
        XCTAssertFalse(comment.isEmpty)
    }

    func test_generate_fullName() {
        // given
        var fullName = ""

        // when
        fullName = sut.generateFullName()
        let name = fullName.split(separator: " ")

        // result
        XCTAssertFalse(fullName.isEmpty)
        XCTAssertEqual(name.count, 2)
    }

    func test_generate_comment() {
        // given
        var commentAuthor = ""
        var commentText = ""

        // when
        let comment = sut.generateComment()
        commentAuthor = comment.author
        let name = commentAuthor.split(separator: " ")
        commentText = comment.text

        // result
        XCTAssertNotNil(comment)
        XCTAssertFalse(commentAuthor.isEmpty)
        XCTAssertEqual(name.count, 2)
        XCTAssertFalse(commentText.isEmpty)
    }

}
