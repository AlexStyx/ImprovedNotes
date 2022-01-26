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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    public func setup(with viewModel: NoteViewModel) {
        title.text = viewModel.title
        dateLabel.text = viewModel.dateString
    }
    
    private func setupUI() {
        addSubivews()
        if frame.width < UIScreen.main.bounds.width / 2 {
            dateLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-20)
                make.leading.equalToSuperview().offset(20)
            }
            
            title.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-5)
            }
        } else {
            dateLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-20)
                make.trailing.trailing.equalToSuperview().offset(-20)
            }
            
            title.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(20)
            }
        }
    }
    
    private func addSubivews() {
        addSubview(title)
        addSubview(dateLabel)
    }
    
    
}
