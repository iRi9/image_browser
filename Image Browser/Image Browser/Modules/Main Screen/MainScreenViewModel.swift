//
//  MainScreenViewModel.swift
//  Image Browser
//
//  Created by Giri Bahari on 02/02/23.
//

import UIKit

protocol MainScreenViewModelDelegate {
    func onLoading(status: Bool)
    func showError(message: String)
    func reloadView()
}

class MainScreenViewModel: NSObject {
    var delegate: MainScreenViewModelDelegate?

    private var api: ImageListDelegate
    private var errorMessage: String?
    private var images: [MainScreenModel] = [MainScreenModel]()

    init(api: ImageListDelegate = ImageListApi()) {
        self.api = api
    }

    func fetchImages(page: Int, limit: Int = 20) {
        delegate?.onLoading(status: true)
        api.fetch(page: page, limit: limit) { status, images, error in
            self.delegate?.onLoading(status: false)
            guard status else {
                self.errorMessage = error?.rawValue
                self.delegate?.showError(message: self.errorMessage ?? "Whops something wrong")
                return
            }

            self.processResponse(images)
        }
    }

    func getNumberOfCell() -> Int {
        images.count
    }

    func getImageCell(at index: Int) -> MainScreenModel {
        images[index]
    }

    func getErrorMessage() -> String? {
        errorMessage
    }

    private func processResponse(_ response: ImageListResponse) {
        let imageList = response.map { res in
            MainScreenModel(authorName: res.author,
                            imageUrl: Config.shared.baseUrl+"/id/\(res.id)/100/86")
        }
        images += imageList
        delegate?.reloadView()
    }
}

struct MainScreenModel {
    var authorName: String
    var imageUrl: String
}
