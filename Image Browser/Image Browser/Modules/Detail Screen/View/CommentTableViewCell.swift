//
//  CommentTableViewCell.swift
//  Image Browser
//
//  Created by Giri Bahari on 04/02/23.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var viewInitialName: UIView!
    @IBOutlet weak var lblInitialName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblRelativeDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        viewInitialName.layer.cornerRadius = viewInitialName.bounds.width * 0.5
    }

    func bind(with detail: DetailCommentModel) {
        lblInitialName.text = detail.authorInitial
        lblName.text = detail.authorName
        lblComment.text = detail.comment
        lblRelativeDate.text = detail.commentDate
    }
    
}

struct DetailCommentModel {
    let id: UUID
    let authorInitial: String
    let authorName: String
    let comment: String
    let commentDate: String
}
