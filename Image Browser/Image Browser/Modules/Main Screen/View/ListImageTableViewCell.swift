//
//  ListImageTableViewCell.swift
//  Image Browser
//
//  Created by Giri Bahari on 03/02/23.
//

import UIKit

class ListImageTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var imgvPhoto: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureCardView()
    }

    func bind(with viewModel: MainScreenModel) {
        imgvPhoto.loadThumbnail(urlString: viewModel.imageUrl)
        lblAuthor.text = viewModel.authorName
    }

    private func configureCardView() {
        // style viewCard
        viewCard.layer.shadowColor = UIColor.systemGray.cgColor
        viewCard.layer.shadowOpacity = 0.4
        viewCard.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewCard.layer.shadowRadius = 5
        viewCard.layer.cornerRadius = 12
        viewCard.layer.borderColor = UIColor.systemGray.cgColor
        viewCard.layer.borderWidth = 0.14
        // style imgvPhoto
        imgvPhoto.clipsToBounds = true
        imgvPhoto.layer.cornerRadius = 12
        imgvPhoto.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
