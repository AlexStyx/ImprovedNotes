//
//  SettingsView.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/17/22.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func didTapCloseButton()
    func didTapSelectButton()
    func didChangeSort()
}


final class SettingsView: UIView {
    
    public var delegate: SettingsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    
    private func setupUI() {
        backgroundColor = Constants.Colors.detailViewBackgroundColor
        addSubviews([
            closeButton,
            rootStackView,
        ])
        rootStackView.addArrangedSubview(selectButton)
        rootStackView.addArrangedSubview(sortButton)
        layout()
    }
    
    private lazy var closeButton: UIButton = {
        $0.backgroundColor = Constants.Colors.buttonBackgroundColor
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.layer.cornerRadius = 25 * 0.5
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var rootStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private lazy var selectButton: UIButton = {
        $0.configuration = .filled()
        $0.configuration?.title = "Select notes"
        $0.configuration?.image = UIImage(systemName: "checkmark.circle")
        $0.configuration?.baseBackgroundColor = Constants.Colors.buttonBackgroundColor
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.imagePlacement = .all
        $0.configuration?.imagePadding = 6
        $0.addTarget(self, action: #selector(didTapSelectOption), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    private lazy var sortButton: UIButton = {
        $0.configuration = .filled()
        $0.configuration?.title = "Sort by: date seen"
        $0.configuration?.image = UIImage(systemName: "arrow.up.arrow.down")
        $0.configuration?.baseBackgroundColor = Constants.Colors.buttonBackgroundColor
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.imagePadding = 6
        
        let sortClosure = { (action: UIAction) in
            self.updateSort(with: action)
        }
        
        $0.menu = UIMenu(children: [
            UIAction(title: "Date seen", state: .on,  handler: sortClosure),
            UIAction(title: "Date changed",  handler: sortClosure),
            UIAction(title: "Date created",  handler: sortClosure)
        ])
        $0.showsMenuAsPrimaryAction = true
        return $0
    }(UIButton())
    
    
    private func updateSort(with action: UIAction) {
        sortButton.menu?.children.forEach { ($0 as? UIAction)?.state = $0 == action ? .on : .off}
        sortButton.setTitle("Sort by: \(action.title.lowercased())", for: .normal)
    }
    
    
    private func layout() {
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(25)
            make.width.equalTo(closeButton.snp.height)
        }
        
        rootStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
        selectButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(45)
        }
        
        sortButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(45)
        }
        
    }
}

// MARK: - Actions
extension SettingsView {
    @objc private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
    
    @objc private func didTapSelectOption() {
        delegate?.didTapSelectButton()
    }
    
    @objc private func didSelectNewSort() {
        delegate?.didChangeSort()
    }
}
