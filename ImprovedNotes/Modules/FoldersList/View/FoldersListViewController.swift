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
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.Colors.backgroudColor
        tableView.separatorColor = .clear
    }
    
    private func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        navigationItem.searchController = searchController
    }
}


// MARK: - View Input
extension FoldersListViewController: FoldersListViewInput {
    
}


extension FoldersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if indexPath.row < data.count {
            configuration.text = data[indexPath.row].name
        } else {
            configuration.text = "Add folder"
            configuration.image = UIImage(systemName: "folder.badge.plus")
            configuration.imageProperties.tintColor = .white
        }
        configuration.textProperties.color = .white

        cell.contentConfiguration = configuration
        cell.contentView.backgroundColor = Constants.Colors.backgroudColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension FoldersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        data = data.filter {$0.name.contains(searchTerm)}
        tableView.reloadData()
        print(searchTerm)
    }
}
