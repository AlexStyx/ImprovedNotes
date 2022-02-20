//
//  NoteCell.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/18/22.
//

import UIKit
import SnapKit

class NoteCell: UICollectionViewCell {
    static let cellId = "noteCell"
    
    private var isEditing: Bool = false {
        didSet {
            selectImageView.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        get {
            return false
        }
        set {
            selectImageView.image = newValue ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private lazy var title: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    private lazy var dateLabel: UILabel = {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return $0
    }(UILabel())
    
    
    private lazy var selectImageView: UIImageView = {
        let image = UIImage(systemName: "circle")
        $0.image = image
        $0.tintColor = .white
        return $0
    }(UIImageView())

    
    
    public func setup(with viewModel: NoteViewModel) {
        title.text = viewModel.title
        dateLabel.text = viewModel.dateString
        isEditing = viewModel.isEditing
        isSelected = viewModel.isSelected
    }
    
    private func setupUI() {
        
        addSubviews([
            title,
            dateLabel,
            selectImageView
        ])
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
        
        selectImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    }
    
}
