//
//  FloatingView.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/22/22.
//

import UIKit

protocol FloatingExpandableButtonDelegate: AnyObject {
    func expandView()
    func narrowView()
    func addNoteButtonTapped()
    func goToFoldersButtonTapped()
}

class FloatingExpandableButton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public weak var delegate: FloatingExpandableButtonDelegate?
    
    private let mainButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Constants.Colors.backgroudColor
        button.setImage(UIImage(named: "list"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Constants.Colors.backgroudColor
        button.setImage(UIImage(named: "add_note"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let goToFoldersButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Constants.Colors.backgroudColor
        button.setImage(UIImage(named: "folders"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.addTarget(self, action: #selector(goToFoldersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        addSubviews([
            addNoteButton,
            goToFoldersButton,
            mainButton
        ])
        layout()
        makeFloatingButtonsRound()
    }
    
    private func layout() {
        mainButton.snp.makeConstraints { make in
            make.width.equalTo(Constants.Sizes.floatingButtonSideSize)
            make.height.equalTo(Constants.Sizes.floatingButtonSideSize)
            make.bottom.equalToSuperview()
        }
        addNoteButton.snp.makeConstraints { make in
            make.width.equalTo(Constants.Sizes.floatingButtonSideSize)
            make.height.equalTo(Constants.Sizes.floatingButtonSideSize)
            make.bottom.equalToSuperview()
        }
        goToFoldersButton.snp.makeConstraints { make in
            make.width.equalTo(Constants.Sizes.floatingButtonSideSize)
            make.height.equalTo(Constants.Sizes.floatingButtonSideSize)
            make.bottom.equalToSuperview()
        }
    }
    
    private func makeFloatingButtonsRound() {
        mainButton.layer.cornerRadius = Constants.Sizes.floatingButtonSideSize * 0.5
        addNoteButton.layer.cornerRadius = Constants.Sizes.floatingButtonSideSize * 0.5
        goToFoldersButton.layer.cornerRadius = Constants.Sizes.floatingButtonSideSize * 0.5
    }
    
    @objc private func mainButtonTapped() {
        if goToFoldersButton.center.y != mainButton.center.y {
            delegate?.narrowView()
            mainButton.setImage(UIImage(named:"list"), for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.addNoteButton.center.y = self.mainButton.center.y
                self.goToFoldersButton.center.y = self.mainButton.center.y
            }
        } else {
            delegate?.expandView()
            mainButton.setImage(UIImage(named: "close"), for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.addNoteButton.frame.origin.y -= (Constants.Sizes.floatingButtonSideSize + 5)
                self.goToFoldersButton.frame.origin.y -= (Constants.Sizes.floatingButtonSideSize * 2 + 10)
            }
        }
        
    }
    
    @objc private func addNoteButtonTapped() {
        delegate?.addNoteButtonTapped()
        
    }
    
    @objc private func goToFoldersButtonTapped() {
        delegate?.goToFoldersButtonTapped()
    }
    
}
