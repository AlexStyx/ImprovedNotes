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
    
    private var viewModel: FoldersListViewModel!
    
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
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}


// MARK: - View Input
extension FoldersListViewController: FoldersListViewInput {
    func update(with viewModel: FoldersListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func performBatchUpdate(with viewModel: FoldersListViewModel, folderChangeItems: [ChangeItem]) {
        self.viewModel = viewModel
        tableView.performBatchUpdates {
            for change in folderChangeItems {
                switch change.type {
                    
                case .insert:
                    tableView.insertRows(at: [change.newIndexPath!], with: .automatic)
                case .delete:
                    tableView.deleteRows(at: [change.indexPath!], with: .automatic)
                case .move:
                    tableView.moveRow(at: change.indexPath!, to: change.newIndexPath!)
                case .update:
                    tableView.reloadRows(at: [change.indexPath!], with: .automatic)
                @unknown default:
                    return
                }
            }
        } completion: { _ in }
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FoldersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewModel?.folders.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if indexPath.row < (viewModel?.folders.count ?? 0) {
            configuration.text = viewModel.folders[indexPath.row].name
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
        if indexPath.row < viewModel.folders.count {
            output?.didSelectFolder(at: indexPath.row)
            return
        }
        
        let alert = UIAlertController(title: "Add Folder", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text else { return }
            self?.output?.didTapAddNoteButton(title: title)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addTextField(configurationHandler: { $0.placeholder = "Title"})
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action -> UIMenu in
            let rename = UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { [weak self] action in
                let alert = UIAlertController(title: "Renam", message: "", preferredStyle: .alert)
                
                let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                    guard let title = alert.textFields?.first?.text else { return }
                    self?.output?.didTapRename(at: indexPath.row, newTitle: title)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addTextField(configurationHandler: { $0.text = self?.viewModel.folders[indexPath.row].name })
                
                alert.addAction(renameAction)
                alert.addAction(cancelAction)
                
                self?.present(alert, animated: true)
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
                self?.output?.didTapRemoveButton(at: indexPath.row)
            }
            var actions = [UIAction]()
            actions.append(rename)
            if self.viewModel.folders.count > 1 {
                actions.append(delete)
            }
            return UIMenu(title: "", children: actions)
        }
        return configuration
    }
}

// MARK: - UISearchResultsUpdating
extension FoldersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let searchTerm = searchController.searchBar.text,
            searchController.isActive
        else { return }
        output?.searchFolders(with: searchTerm)
    }
}

// MARK: - UISearchBarDelegate
extension FoldersListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        output?.stopSearching()
    }
}
