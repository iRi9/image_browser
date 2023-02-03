//
//  DetailViewController.swift
//  Image Browser
//
//  Created by Giri Bahari on 04/02/23.
//

import UIKit

class DetailViewController: UIViewController {

    var detailData: MainScreenModel?
    static var identifier: String {
        return String(describing: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Detail"

    }
}
