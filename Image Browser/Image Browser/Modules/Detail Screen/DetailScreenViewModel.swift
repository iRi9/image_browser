//
//  DetailScreenViewModel.swift
//  Image Browser
//
//  Created by Giri Bahari on 04/02/23.
//

import Foundation

class DetailScreenViewModel {
    var delegate: ViewModelDelegate?

    private var provider: DetailCommentProviderDelegagte
    private var detail: DetailModel?
    init(provider: DetailCommentProviderDelegagte = DetailCommentProvider()) {
        self.provider = provider
    }

    func fetchDetailComment(imageId: Int) {
        provider.getDetailComments(by: Int64(imageId)) { comments in
            DispatchQueue.main.async { [weak self] in
                self?.processDetailScreenModel(imageId: imageId, comments: comments)
            }
        }
    }

    func addComment(imageId: Int) {
        let comment = CommentGenerator.shared.generateComment()
        let detailComment = DetailComment(id: UUID(), imageId: Int64(imageId), authorInitialName: comment.authorInitial, authorName: comment.author, comment: comment.text, createdAt: Date())
        delegate?.onLoading(status: true)
        provider.saveDetailImageComment(detailComment) { status in
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.onLoading(status: false)
                self?.fetchDetailComment(imageId: imageId)
            }
        }
    }

    func deleteComment(by id: UUID, on imageId: Int) {
        delegate?.onLoading(status: true)
        provider.deleteDetailImageComment(by: id) { status in
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.onLoading(status: false)
                self?.fetchDetailComment(imageId: imageId)
            }
        }
    }

    func getDetail() -> DetailModel? {
        return detail
    }

    func getNumberOfCell() -> Int {
        guard let detail = detail,
              let comments = detail.comments else {
            return 0
        }
        return comments.count
    }

    private func processDetailScreenModel(imageId: Int, comments: [DetailComment]) {
        let imageUrl = Config.shared.baseUrl+"/id/\(imageId)/400/300"
        guard comments.count > 0 else {
            detail = DetailModel(imageUrl: imageUrl, comments: nil)
            delegate?.reloadView()
            return
        }
        let detailComments = comments.map { comment in
            DetailCommentModel(id: comment.id, authorInitial: comment.authorInitialName, authorName: comment.authorName, comment: comment.comment, commentDate: RelativeDate.string(for: comment.createdAt))
        }
        detail = DetailModel(imageUrl: imageUrl, comments: detailComments)
        delegate?.reloadView()
    }

}

struct DetailModel {
    var imageUrl: String
    var comments: [DetailCommentModel]?
}
