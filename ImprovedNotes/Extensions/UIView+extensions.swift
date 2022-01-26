//
//  UIView+extensions.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/22/22.
//

import UIKit

extension UIView {
    public func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}
