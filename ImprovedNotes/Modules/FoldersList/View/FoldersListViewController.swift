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
        tableView.delegate = self
        tableView.dataSource = self
        output?.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public
    func setupViewReadyBlock(block: @escaping () -> Void) {
        viewReadyBlock = block;
    }

    // MARK: - Private
    
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    
}


extension FoldersListViewController {
    private func setupUI() {
        view.addSubviews([tableView])
        layout()
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
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
        cell.contentConfiguration = configuration
        return cell
    }
}
