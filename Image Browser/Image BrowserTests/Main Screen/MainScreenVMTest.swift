//
//  MainScreenVMTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 02/02/23.
//

import XCTest
@testable import Image_Browser

final class MainScreenVMTest: XCTestCase {

    var sut: MainScreenViewModel!
    var mockApi: MockApi!
    var delegateMock: MockVM!

    override func setUp() {
        super.setUp()
        mockApi = MockApi()
        sut = MainScreenViewModel(api: mockApi)
        delegateMock = MockVM()
        sut.delegate = delegateMock
    }

    override func tearDown() {
        sut = nil
        mockApi = nil
        delegateMock = nil
        super.tearDown()
    }

    func test_fetch_images_success() {
        // when
        sut.fetchImages(page: 1)

        // result
        XCTAssert(mockApi.successFetchImages)
    }

    func test_fetch_images_failed() {
        // given
        let error = ApiError.invalidService

        // when
        sut.fetchImages(page: 1)
        mockApi.fetchImagesFailed()

        // result
        XCTAssertNotNil(sut.getErrorMessage())
        XCTAssertEqual(sut.getErrorMessage(), error.rawValue)
    }

    func test_loading_when_fetching_images() {
        // given
        let loadingStatus = true

        // when
        sut.fetchImages(page: 1)

        // result
        XCTAssertEqual(delegateMock.isLoading, loadingStatus)
    }

    func test_error_fetching_images() {
        // given
        let isError = true

        // when
        sut.fetchImages(page: 1)
        mockApi.fetchImagesFailed()

        //result
        XCTAssertEqual(delegateMock.isError, isError)
    }

    func test_reload_view_after_fetching_images() {
        // given
        let isReloadView = true

        // when
        sut.fetchImages(page: 1)
        mockApi.fetchMovieSuccess()

        //result
        XCTAssertEqual(delegateMock.isReloadView, isReloadView)
    }

}

// MARK: - Mock API
class MockApi: ImageListDelegate {
    var successFetchImages = false
    var complete: ((Bool, ImageListResponse, ApiError?) -> Void)!
    var completeImages = ImageListResponse()

    func fetch(page: Int, limit: Int, completion: @escaping (Bool, ImageListResponse, ApiError?) -> Void) {
        successFetchImages = true
        complete = completion
    }

    func fetchMovieSuccess() {
        complete(true, completeImages, nil)
    }


    func fetchImagesFailed() {
        complete(false, completeImages, .invalidService)
    }
}


// MARK: - Mock VM
class MockVM: MainScreenViewModelDelegate {
    var isLoading = false
    var isError = false
    var isReloadView = false

    func onLoading(status: Bool) {
        isLoading = status
    }

    func showError(message: String) {
        isError = !message.isEmpty
    }

    func reloadView() {
        isReloadView = true
    }
}
