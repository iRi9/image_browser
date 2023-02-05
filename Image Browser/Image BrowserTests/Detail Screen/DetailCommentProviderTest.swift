//
//  DetailCommentProviderTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 05/02/23.
//

import XCTest

final class DetailCommentProviderTest: XCTestCase {

    var sut: DetailCommentProvider!

    override func setUp() {
        super.setUp()
        let coreDataManager = CoreDataManager(.inMemory)
        sut = DetailCommentProvider(backgroundContext: coreDataManager.backgroundContext)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_save_detail_image_comment() {
        // given
        let detailComment = DetailComment(id: UUID(), imageId: 0, authorInitialName: "JD", authorName: "Jhon Doe", comment: "Test comment", createdAt: Date())
        var saveStatus = false

        // when
        let expect = XCTestExpectation(description: "callback")
        sut.saveDetailImageComment(detailComment) { status  in
            expect.fulfill()
            saveStatus = status
        }
        wait(for: [expect], timeout: 3)

        // result
        XCTAssertTrue(saveStatus)
    }

    func test_get_detail_image_comments_empty() {
        // given
        var detailComments = [DetailComment]()

        // when
        let expect = XCTestExpectation(description: "callback")
        sut.getDetailComments(by: 0) { comments in
            expect.fulfill()
            detailComments = comments
        }
        wait(for: [expect], timeout: 3)

        // result
        XCTAssertTrue(detailComments.isEmpty)
    }

    func test_get_detail_image_comments_not_empty() {
        // given
        var detailComments = [DetailComment]()
        let detailComment1 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "JD", authorName: "Jhon Doe", comment: "Test comment", createdAt: Date())
        let detailComment2 = DetailComment(id: UUID(), imageId: 1, authorInitialName: "SD", authorName: "Susan Doe", comment: "Test comment2", createdAt: Date())
        let detailComment3 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "TD", authorName: "Tonny Doe", comment: "Test comment3", createdAt: Date())
        var saveStatus = false

        // when
        let expectSave = XCTestExpectation(description: "callback save comment")
        sut.saveDetailImageComment(detailComment1) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        XCTAssertTrue(saveStatus)
        saveStatus = false

        sut.saveDetailImageComment(detailComment2) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        XCTAssertTrue(saveStatus)
        saveStatus = false

        sut.saveDetailImageComment(detailComment3) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        wait(for: [expectSave], timeout: 3)
        XCTAssertTrue(saveStatus)

        let expectGetComments = XCTestExpectation(description: "callback get comments")
        sut.getDetailComments(by: 0) { comments in
            expectGetComments.fulfill()
            detailComments = comments
        }
        wait(for: [expectGetComments], timeout: 3)

        // result
        XCTAssertEqual(detailComments.count, 2)
        XCTAssertFalse(detailComments.isEmpty)
    }

    func test_get_detail_image_comments_desc_sort() {
        // given
        var detailComments = [DetailComment]()
        let detailComment1 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "JD", authorName: "Jhon Doe", comment: "Test comment1", createdAt: Date())
        let detailComment2 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "SD", authorName: "Susan Doe", comment: "Test comment2", createdAt: Date())
        let detailComment3 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "TD", authorName: "Tonny Doe", comment: "Test comment3", createdAt: Date())
        var saveStatus = false

        // when
        let expectSave = XCTestExpectation(description: "callback save comment")
        sut.saveDetailImageComment(detailComment1) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        XCTAssertTrue(saveStatus)
        saveStatus = false

        sut.saveDetailImageComment(detailComment2) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        XCTAssertTrue(saveStatus)
        saveStatus = false

        sut.saveDetailImageComment(detailComment3) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        wait(for: [expectSave], timeout: 3)
        XCTAssertTrue(saveStatus)

        let expectGetComments = XCTestExpectation(description: "callback get comments")
        sut.getDetailComments(by: 0) { comments in
            expectGetComments.fulfill()
            detailComments = comments
        }
        wait(for: [expectGetComments], timeout: 3)
        
        // result
        XCTAssertEqual(detailComments.count, 3)
        XCTAssertFalse(detailComments.isEmpty)
        XCTAssertEqual(detailComments[0].id, detailComment3.id)
    }

    func test_delete_detail_image_comment() {
        // given
        var detailComments = [DetailComment]()
        let detailComment1 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "JD", authorName: "Jhon Doe", comment: "Test comment", createdAt: Date())
        let detailComment2 = DetailComment(id: UUID(), imageId: 1, authorInitialName: "SD", authorName: "Susan Doe", comment: "Test comment2", createdAt: Date())
        let detailComment3 = DetailComment(id: UUID(), imageId: 0, authorInitialName: "TD", authorName: "Tonny Doe", comment: "Test comment3", createdAt: Date())
        var saveStatus = false
        var deleteStatus = false

        // when
        let expectSave = XCTestExpectation(description: "callback save comment")
        sut.saveDetailImageComment(detailComment1) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        XCTAssertTrue(saveStatus)
        saveStatus = false

        sut.saveDetailImageComment(detailComment2) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        XCTAssertTrue(saveStatus)
        saveStatus = false

        sut.saveDetailImageComment(detailComment3) { status  in
            expectSave.fulfill()
            saveStatus = status
        }
        wait(for: [expectSave], timeout: 3)
        XCTAssertTrue(saveStatus)

        let expectGetComments = XCTestExpectation(description: "callback get comments")
        sut.getDetailComments(by: 0) { comments in
            expectGetComments.fulfill()
            detailComments = comments
        }
        wait(for: [expectGetComments], timeout: 3)
        XCTAssertEqual(detailComments.count, 2)

        let expectDeleteComment = XCTestExpectation(description: "callback delete comment")
        sut.deleteDetailImageComment(by: detailComment2.id) { status  in
            expectDeleteComment.fulfill()
            deleteStatus = status
        }
        wait(for: [expectDeleteComment], timeout: 1)

        let expectGetCommentsAfterDelete = XCTestExpectation(description: "callback get comments after delete")
        sut.getDetailComments(by: 0) { comments in
            expectGetCommentsAfterDelete.fulfill()
            detailComments = comments
        }
        wait(for: [expectGetCommentsAfterDelete], timeout: 3)
        XCTAssertEqual(detailComments.count, 2)


        // result
        XCTAssertTrue(deleteStatus)
    }

}
