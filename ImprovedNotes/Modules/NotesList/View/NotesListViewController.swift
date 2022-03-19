//
//  NotesListNotesListViewController.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit
import SideMenu
import SnapKit
import CoreData
import AVKit

final class NotesListViewController: UIViewController {
    
    var output: NotesListViewOutput?
    var viewReadyBlock: (() -> Void)?
    
    private var viewModel: NotesListViewModel!
    private var seachDebounceTimer: Timer?
    
    private lazy var settingsMenuCurrentYPosition: CGFloat = 0.0
    
    // MARK: - UI
    private lazy var leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(goToFoldersButtonTapped))
    private lazy var rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapOptionsButton(_:)))
        
    private lazy var collectionView: UICollectionView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.cellId)
        $0.backgroundColor = Constants.Colors.backgroudColor
        if let layout = $0.collectionViewLayout as? NotesListLayout {
            layout.delegate = self
        }
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: NotesListLayout()))
        
    private lazy var settingsView: SettingsView = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(settingsViewPanGesture(_:)))
        $0.addGestureRecognizer(panGestureRecognizer)
        $0.delegate = self
        $0.layer.cornerRadius = 10
        return $0
    }(SettingsView())
        
    private lazy var floatingButton: UIButton = {
        $0.configuration = .filled()
        $0.configuration?.image = UIImage(systemName: "plus")
        $0.configuration?.baseBackgroundColor = Constants.Colors.buttonBackgroundColor
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.cornerStyle = .capsule
        $0.configuration?.imagePlacement = .all
        $0.configuration?.titleAlignment = .center
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 5.0
        $0.addTarget(self, action: #selector(createNoteButtonTapped), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    private lazy var blurView: UIVisualEffectView = {
        $0.effect = UIBlurEffect(style: .dark)
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.alpha = 0.0
        $0.isHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBlurView))
        $0.addGestureRecognizer(tap)
        return $0
    }(UIVisualEffectView())
  
    private lazy var tapToAddFirstButton: UIButton = {
        $0.configuration = .plain()
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.title = "Tap to add ----->"
        return $0
    }(UIButton())

    
    private let colors = [
        UIColor(red: 240 / 255, green: 163/255, blue: 178/255, alpha: 1.0),
        UIColor(red: 204 / 255, green: 227/255, blue: 1/255, alpha: 1.0),
        UIColor(red: 227 / 255, green: 218/255, blue: 159/255, alpha: 1.0),
        UIColor(red: 227 / 255, green: 159/255, blue: 224/255, alpha: 1.0),
        UIColor(red: 203 / 255, green: 159/255, blue: 227/255, alpha: 1.0),
        UIColor(red: 159 / 255, green: 210/255, blue: 227/255, alpha: 1.0),
        UIColor(red: 131 / 255, green: 193/255, blue: 235/255, alpha: 1.0)
    ]
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didTriggerViewWillAppearEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isViewLoaded, let viewReadyBlock = viewReadyBlock {
            viewReadyBlock()
            self.viewReadyBlock = nil
        }
        setupUI()
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        output?.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public
    func setupViewReadyBlock(block: @escaping () -> Void) {
        viewReadyBlock = block;
    }
    
    public func update(with viewModel: NotesListViewModel) {
        self.viewModel = viewModel
        floatingButton.isHidden = viewModel.isEditing
        updateNavigationBar()
        updateToolBar()
        updateCollectionView()
    }
    
    func performBatchUpdate(with viewModel: NotesListViewModel, changeItems: [ChangeItem]) {
        self.viewModel = viewModel
        collectionView.performBatchUpdates {
            for change in changeItems {
                switch change.type {
                case .insert:
                    collectionView.insertItems(at: [change.newIndexPath!])
                case .delete:
                    collectionView.deleteItems(at: [change.indexPath!])
                case .move:
                    collectionView.moveItem(at: change.indexPath!, to: change.newIndexPath!)
                case .update:
                    collectionView.reloadItems(at: [change.indexPath!])
                @unknown default:
                    return
                }
            }
        } completion: { _ in }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        output?.didSetEditing(to: editing)
    }
    
    // MARK: - Private    
    private func updateNavigationBar() {
        navigationItem.rightBarButtonItem = viewModel.isEditing ? editButtonItem : rightBarButtonItem
        navigationItem.leftBarButtonItem = viewModel.isEditing ? nil : leftBarButtonItem
    }
    
    private func updateToolBar() {
        navigationController?.setToolbarHidden(!viewModel.isEditing, animated: true)
        toolbarItems?.first?.title = viewModel.moveToActionTitle
        toolbarItems?.last?.title = viewModel.removeActionTitle
    }
    
    private func updateCollectionView() {
        collectionView.allowsMultipleSelection = viewModel.isEditing
        collectionView.reloadData()
    }
}


// MARK: - View Input
extension NotesListViewController: NotesListViewInput {
    
}


//MARK: - Setup UI
extension NotesListViewController {
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroudColor
        
        view.addSubviews([
            collectionView,
            blurView,
            floatingButton,
            tapToAddFirstButton,
            settingsView,
        ])
        
        layout()
        
        setupNavigationController()
        setupSearchController()
    }
    
    private func layout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalTo(50)
            make.height.equalTo(50)

        }
        
        tapToAddFirstButton.snp.makeConstraints { make in
            make.trailing.equalTo(floatingButton.snp.leading).offset(-10)
            make.height.equalTo(floatingButton)
            make.centerY.equalTo(floatingButton)
        }
        
        let settingsViewDefaultFrame = CGRect(x: .zero, y: view.bounds.height, width: view.bounds.width, height: 200)
        settingsView.frame = settingsViewDefaultFrame
        blurView.frame = view.bounds
    }
    
    private func setupNavigationController() {
        setupNavgationBar()
        setupToolbar()
    }
    
    private func setupNavgationBar() {
        title = "Notes"
    
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.backgroudColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    
    private func setupToolbar() {
        navigationController?.setToolbarHidden(true, animated: true)
        let moveToFolderItem = UIBarButtonItem(title: "Move All", style: .plain, target: self, action: #selector(moveToButtonTapped))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let removeItem = UIBarButtonItem(title:"Remove All", style: .plain, target: self, action: #selector(removeButtonTapped))
        toolbarItems = [moveToFolderItem, flexibleItem, removeItem]
        navigationController?.toolbar.barTintColor = Constants.Colors.backgroudColor
        navigationController?.toolbar.tintColor = .white
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}


// MARK: - Actions
extension NotesListViewController {
    
    @objc private func didTapOptionsButton(_ sender: UIBarButtonItem) {
        if settingsView.frame.origin.y >= view.bounds.height {
            openSettingsView()
        }
    }
    
    @objc private func goToFoldersButtonTapped() {
        output?.didTapGoToFoldersButton()
    }
    
    @objc private func createNoteButtonTapped() {
        output?.didTapAddNoteButton()
//        let alert = UIAlertController(title: "Add Folder", message: "", preferredStyle: .alert)
//        
//        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
//            guard
//                let title = alert.textFields?.first?.text,
//                !title.isEmpty
//            else { return }
//            let note = Note(context: CoreDataStack.shared.managedContext)
//            note.title = title
//            note.id = UUID()
//            note.dateCreated = Date()
//            FoldersService.shared.currentFolder()?.addToNotes(note)
//            CoreDataStack.shared.saveContext()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        
//        alert.addTextField(configurationHandler: { $0.placeholder = "Title"})
//        
//        alert.addAction(addAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
        
    }
    
    @objc private func moveToButtonTapped() {
        print(#function)
    }
    
    @objc private func removeButtonTapped() {
        print(#function)
    }
    
    @objc private func didTapBlurView() {
        closeSettingsView()
    }
    
    @objc private func settingsViewPanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            settingsMenuCurrentYPosition = settingsView.frame.origin.y
        case .changed:
            let yCoordinate = sender.translation(in: self.view).y
           
            var newYPoint = settingsMenuCurrentYPosition + yCoordinate
            if newYPoint >= view.bounds.height - settingsView.frame.height {
                settingsView.frame.origin.y = newYPoint
            } else {
                newYPoint = view.bounds.height - settingsView.frame.height
                settingsView.frame.origin.y = newYPoint
            }
        case .ended:
            if settingsView.frame.origin.y > view.bounds.height - settingsView.frame.height * 0.5 || sender.velocity(in: view).y > 1500 {
                closeSettingsView()
            } else {
                openSettingsView()
            }
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NotesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.notes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.cellId, for: indexPath) as? NoteCell else { fatalError() }
        cell.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        guard let note = viewModel?.notes[indexPath.row] else { fatalError("Cannot find viewModel") }
        cell.setup(with: note)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        output?.didSelectNote(at: indexPath.row)
    }
}


// MARK: - NotesListLayoutDelegate
extension NotesListViewController: NotesListLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: NotesListLayout, heightForLabelsAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (layout.collectionViewContentSize.width / 2) - 32
        guard let viewModel = viewModel?.notes[indexPath.row] else { return 0 }
        return viewModel.title.height(width: width, font: Constants.Fonts.noteTitleFont) + viewModel.dateString.height(width: width, font: Constants.Fonts.noteDateFont) + 40
    }
}

// MARK: - UISearchResultsUpdating
extension NotesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        print(searchTerm)
    }
}

extension NotesListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}


// MARK: - SettingsView
extension NotesListViewController: SettingsViewDelegate {
    
    func didTapCloseButton() {
        closeSettingsView()
    }
    
    func didTapSelectButton() {
        setEditing(true, animated: true)
        closeSettingsView()
    }
    
    func didChangeSort() {
        print(#function)
    }
    
    private func closeSettingsView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.settingsView.frame.origin.y = self?.view.bounds.height ?? 0
            self?.blurView.alpha = 0
        } completion: { [weak self] finished in
            self?.blurView.isHidden = finished
        }
    }
    
    private func openSettingsView() {
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.settingsView.frame.origin.y = (self?.view.bounds.height ?? 0) - (self?.settingsView.frame.height ?? 0)
            self?.blurView.alpha = 1
        }
    }
}
