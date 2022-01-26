//
//  NotesListNotesListViewController.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 18/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit
import SideMenu

final class NotesListViewController: UIViewController {
    
    var output: NotesListViewOutput?
    var viewReadyBlock: (() -> Void)?
    
    private var floatingViewExpandedConsstraint: NSLayoutConstraint?
    private var floatingViewUnexpandedConsstraint: NSLayoutConstraint?
    
    
    private let colors = [
        UIColor(red: 240 / 255, green: 163/255, blue: 178/255, alpha: 1.0),
        UIColor(red: 204 / 255, green: 227/255, blue: 1/255, alpha: 1.0),
        UIColor(red: 227 / 255, green: 218/255, blue: 159/255, alpha: 1.0),
        UIColor(red: 227 / 255, green: 159/255, blue: 224/255, alpha: 1.0),
        UIColor(red: 203 / 255, green: 159/255, blue: 227/255, alpha: 1.0),
        UIColor(red: 159 / 255, green: 210/255, blue: 227/255, alpha: 1.0),
        UIColor(red: 131 / 255, green: 193/255, blue: 235/255, alpha: 1.0)
    ]
    
    private let data = [
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date())),
        NoteViewModel(note: Note(title: "Note title", date: Date()))
        
    ]
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didTriggerViewWillAppearEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard floatingView?.superview != nil else {  return }
        DispatchQueue.main.async {
            self.floatingView?.removeFromSuperview()
            self.floatingView = nil
        }
        super.viewWillDisappear(animated)
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
    
    // MARK: - Private
    
    
    
    // MARK: - UI
    
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: NotesListViewController.collectionViewLayout())
    
    private let navigationBar = NavigationBar()
    
    private var floatingView: FloatingExpandableButton?
    private var goToFoldersButton: UIButton?
    private var closeButton: UIButton?
    
    
    
}


// MARK: - View Input
extension NotesListViewController: NotesListViewInput {
    
}

//MARK: - Setup UI
extension NotesListViewController {
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroudColor
        addSubviews()
        layout()
        setupCollectionView()
        setupCustomNavigationBar()
        createFloatingButton()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(navigationBar)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.bottom.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(140)
        }
        
    }
    
    private func setupCustomNavigationBar() {
        navigationBar.backgroundColor = Constants.Colors.backgroudColor
        navigationBar.contentView.backgroundColor = Constants.Colors.backgroudColor
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.cellId)
        collectionView.backgroundColor = Constants.Colors.backgroudColor
    }
    
}

// MARK: - Actions
extension NotesListViewController {
   
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NotesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.cellId, for: indexPath) as? NoteCell else { fatalError() }
        cell.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        let note = data[indexPath.row]
        cell.setup(with: note)
        return cell
    }
}

// MARK: - CollectionView Layout
extension NotesListViewController {
    static func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let basicItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let basicItemInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        basicItem.contentInsets = basicItemInsets
        let horizontalBasicGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/6)
            ),
            subitem: basicItem,
            count: 2
        )
        
        
        let wideItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/6))
        )
        
        wideItem.contentInsets = basicItemInsets
        
        
        let verticalItem1 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(3/5)
            )
        )
        
        verticalItem1.contentInsets = basicItemInsets
        
        let verticalItem2 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(2/5)
            )
        )
        
        verticalItem2.contentInsets = basicItemInsets
        
        let verticalGroup1 = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [
                verticalItem1,
                verticalItem2
            ]
        )
        
        let verticalGroup2 = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [
                verticalItem2,
                verticalItem1
            ]
        )
        
        let horizontalGroupOfVerticalGroups = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(4/6)
            ),
            subitems: [
                verticalGroup1,
                verticalGroup2
            ]
        )
        
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1.1)),
            subitems: [
                horizontalBasicGroup,
                wideItem,
                horizontalGroupOfVerticalGroups
            ]
        )
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Expandable floating buttons
extension NotesListViewController
{
    private func createFloatingButton() {
        floatingView = FloatingExpandableButton()
        floatingView?.delegate = self
        floatingView?.translatesAutoresizingMaskIntoConstraints = false
        constrainFloatingButtonToWindow()
    }
    
    
    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow,
                  let floatingButton = self.floatingView
            else { return }
            
            keyWindow.addSubview(floatingButton)
            
    
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: 30).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                                                       constant: 50).isActive = true
            
            floatingButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
            self.floatingViewUnexpandedConsstraint = floatingButton.heightAnchor.constraint(equalToConstant: 75)
            self.floatingViewExpandedConsstraint = floatingButton.heightAnchor.constraint(equalToConstant: 75 * 3 + 5 * 2)
            self.floatingViewUnexpandedConsstraint?.isActive = true
        }
    }
}

extension NotesListViewController: FloatingExpandableButtonDelegate {
    
    public func expandView() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        floatingViewUnexpandedConsstraint?.isActive = false
        floatingViewExpandedConsstraint?.isActive = true
        keyWindow.layoutIfNeeded()
    }
    
    public func narrowView() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        floatingViewExpandedConsstraint?.isActive = false
        floatingViewUnexpandedConsstraint?.isActive = true
    }
    
    public func addNoteButtonTapped() {
        output?.didTapAddNoteButton()
    }
    
    public func goToFoldersButtonTapped() {
        output?.didTapGoToFoldersButton()
    }
}

