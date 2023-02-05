//
//  DetailScreenViewModelTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 04/02/23.
//

import XCTest
@testable import Image_Browser

final class DetailViewModelTest: XCTestCase {

    var sut: DetailScreenViewModel!
    var mockProvider: MockProvider!

    override func setUp() {
        super.setUp()
        mockProvider = MockProvider()
        sut = DetailScreenViewModel(provider: mockProvider)
    }

    override func tearDown() {
        sut = nil
        mockProvider = nil
        super.tearDown()
    }

    func test_get_detail_nil() {
        // given
        var detailModel: DetailModel?

        // when
        sut.fetchDetailComment(imageId: 0)
        detailModel = sut.getDetail()

        // result
        XCTAssertNil(detailModel)
    }

    func test_get_detail_comments() {
        // given
        let imageId = 0

        // when
        sut.fetchDetailComment(imageId: imageId)
        mockProvider.getDetailComments(by: Int64(imageId)) { _ in }

        // result
        XCTAssertTrue(mockProvider.successGetComment)
    }

    func test_add_comment() {
        // given
        let imageId = 0

        // when
        sut.addComment(imageId: imageId)

        // result
        XCTAssertTrue(mockProvider.successSaveComment)
    }

    func test_delete_comment() {
        // given
        let id = UUID()
        let imageId = 0

        // when
        sut.deleteComment(by: id, on: imageId)

        // result
        XCTAssertTrue(mockProvider.successDeleteComment)
    }


}

// MARK: - Mock Privider
class MockProvider: DetailCommentProviderDelegagte {
    var successSaveComment = false
    var successDeleteComment = false
    var successGetComment = false

    func saveDetailImageComment(_ detailComment: DetailComment, completion: @escaping (Bool) -> Void) {
        successSaveComment = true
    }

    func getDetailComments(by imageId: Int64, completion: @escaping ([DetailComment]) -> Void) {
        successGetComment = true
    }

    func deleteDetailImageComment(by id: UUID, completion: @escaping (Bool) -> Void) {
        successDeleteComment = true
    }

}
