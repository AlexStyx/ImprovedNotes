//
//  FoldersListFoldersListViewController.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 23/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit
import SnapKit

final class FoldersListViewController: UIViewController {
    
    var output: FoldersListViewOutput?
    var viewReadyBlock: (() -> Void)?
    
    var data = [FolderViewModel]()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didTriggerViewWillAppearEvent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isViewLoaded, let viewReadyBlock = viewReadyBlock {
            viewReadyBlock()
            self.viewReadyBlock = nil
        }
        for i in 1...30 {
            data.append(FolderViewModel(name: "folder_\(i)"))
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "folderCell")
        setupUI()
        output?.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public
    func setupViewReadyBlock(block: @escaping () -> Void) {
        viewReadyBlock = block;
    }
    
    // MARK: - Private
    
    
    // MARK: - UI
    
    private let tableView = UITableView()
    
    
}


// MARK: - setupUI
extension FoldersListViewController {
    private func setupUI() {
        view.addSubviews([tableView])
        layout()
        setupNavigationControler()
        setupSearchController()
        setupTableView()
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationControler() {
        title = "Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.backgroudColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGray6]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGray6]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.Colors.backgroudColor
        tableView.separatorColor = .systemGray6
    }
    
    private func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Start typing..."
        searchController.searchBar.searchTextField.textColor = .systemGray6
        navigationItem.searchController = searchController
    }
}


// MARK: - View Input
extension FoldersListViewController: FoldersListViewInput {
    
}


extension FoldersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = data[indexPath.row].name
        configuration.textProperties.color = .systemGray6
        cell.contentConfiguration = configuration
        cell.contentView.backgroundColor = Constants.Colors.backgroudColor
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension FoldersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        print(searchTerm)
    }
}
