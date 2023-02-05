//
//  DetailHeaderView.swift
//  Image Browser
//
//  Created by Giri Bahari on 04/02/23.
//

import UIKit

class DetailHeaderView: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }

    lazy var imgvPhoto: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.translatesAutoresizingMaskIntoConstraints = false

        return imgv
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imgvPhoto)
        NSLayoutConstraint.activate([
            imgvPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgvPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: imgvPhoto.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: imgvPhoto.bottomAnchor),
            imgvPhoto.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }

    func bind(with imgUrl: String?) {
        guard let imgUrl = imgUrl else { return }
        imgvPhoto.loadThumbnail(urlString: imgUrl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
