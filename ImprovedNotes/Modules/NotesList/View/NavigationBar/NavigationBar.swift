//
//  NavigationBar.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/19/22.
//

import UIKit

class NavigationBar: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var sortMenu: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupUI()
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        var searchBarWidth: CGFloat
        var sortMenuWidth: CGFloat
        
        if searchBar.frame.width == 0 {
            searchBarWidth = self.searchButton.frame.origin.x - self.notesLabel.frame.origin.x - self.notesLabel.frame.width - 10
            sortMenuWidth = 0
            searchButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            searchBarWidth = 0
            sortMenuWidth = 162
            searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
        UIView.animate(withDuration: 0.3) {
            self.sortMenu.frame.size.width = sortMenuWidth
        }
        UIView.animate(withDuration: 0.3) {
            self.sortMenu.alpha = self.searchBar.frame.width == 0 ? 0 : 1
            self.searchBar.frame.size.width = searchBarWidth
        }
    }
    
    private func commonInit() {
        let bundle = Bundle(for: NavigationBar.self)
        bundle.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        setupSearchButton()
        setupSearchBar()
        setupSortMenu()
    }
    
    
    private func setupSearchButton() {
        searchButton.layer.cornerRadius = 10
    }
    
    private func setupSearchBar() {
        searchBar.isHidden = false
        searchBar.center.y = notesLabel.center.y
        searchBar.frame.origin.x = notesLabel.frame.origin.x + notesLabel.frame.width + 5
        searchBar.frame.size.width = 0
    }
    
    lazy var selectSortValue = { [weak self]  (action: UIAction) in
        self?.sortMenu.setTitle("Sorted by: \(action.title.lowercased())", for: .normal)
        self?.sortMenu.sizeToFit()
        for menuAction in self!.sortMenu.menu!.children {
            if menuAction == action {
                (menuAction as? UIAction)?.state = .on
            } else {
                (menuAction as? UIAction)?.state = .off
            }
        }
    }
    
    private func setupSortMenu() {
        self.sortMenu.frame.origin.x = notesLabel.frame.origin.x + notesLabel.frame.width + 5
        self.sortMenu.center.y = notesLabel.center.y
        self.sortMenu.titleLabel?.textAlignment = .left
                sortMenu.menu = UIMenu(children: [
            UIAction(title: "Date created", state: .on, handler: selectSortValue),
            UIAction(title: "Date seen", handler: selectSortValue),
            UIAction(title: "Date changed", handler: selectSortValue)
          ])
        
    }

}
