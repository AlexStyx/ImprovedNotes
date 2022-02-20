//
//  String+extensions.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/16/22.
//

import UIKit

extension String {
    public func height(width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font
        label.text = self
        
        let height = label.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        return height
    }
}
