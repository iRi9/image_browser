//
//  UITableViewCell+Extension.swift
//  Image Browser
//
//  Created by Giri Bahari on 02/02/23.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
