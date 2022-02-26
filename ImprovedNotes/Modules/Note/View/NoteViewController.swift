//
//  NoteNoteViewController.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 21/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit
import SnapKit

final class NoteViewController: UIViewController {
    
    var output: NoteViewOutput?
    var viewReadyBlock: (() -> Void)?
    
    // MARK: - UI
    private lazy var content = [ContentViewModel]()
    
    private var lastViewBottomConstraint: Constraint?
    private lazy var scrollView: UIScrollView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
        $0.addGestureRecognizer(tap)
        return $0
    }(UIScrollView())
    
    private lazy var contentView: UIView = {
        $0.backgroundColor = Constants.Colors.backgroudColor
        return $0
    }(UIView())
    
    private lazy var titleTextView: UITextView = {
        $0.textColor = .white
        $0.backgroundColor = Constants.Colors.backgroudColor
        $0.isScrollEnabled = false
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        $0.tag = Constants.Tags.noteTitleTextViewTag
        return $0
    }(UITextView())
    
    private lazy var dateLabel: UILabel = {
        $0.textColor = .systemGray2
        $0.text = "30.01.2022"
        return $0
    }(UILabel())
    
    private lazy var titleTextViewPlaceholder: UILabel = {
        $0.text = "Note title"
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        $0.textColor = .white
        $0.alpha = 0.5
        return $0
    }(UILabel())
    
    private var contentViews = [UIView]()
    
    
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
        setupUI()
        output?.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public
    func setupViewReadyBlock(block: @escaping () -> Void) {
        viewReadyBlock = block;
    }
    
    // MARK: - Private
    
    
}

//MARK: - Setup UI
extension NoteViewController {
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroudColor
        view.addSubviews([
            scrollView
        ])
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            titleTextView,
            titleTextViewPlaceholder,
            dateLabel
        ])
        
        layout()
        
        setupTitleTextView()
        setupNavigationController()
        
        if content.isEmpty {
            content.append(ContentViewModel(id: UUID(), type: .text, data: nil))
        }
        
        for contentItem in content {
            switch contentItem.type {
            case .text:
                addTextView(with: contentItem)
            }
        }
    }
    
    
    private func layout() {
        
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        titleTextViewPlaceholder.snp.makeConstraints { make in
            make.leading.equalTo(titleTextView).offset(5)
            make.centerY.equalTo(titleTextView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.backgroudColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    private func setupTitleTextView() {
        titleTextView.delegate = self
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if textView.tag == Constants.Tags.noteTitleTextViewTag {
            titleTextViewPlaceholder.isHidden = !text.isEmpty
            if text.last == "\n" {
                textView.text.removeLast()
                textView.resignFirstResponder()
                for contentItem in content {
                    if contentItem.type == .text {
                        if let index = content.firstIndex(of: contentItem) {
                            contentViews[index].becomeFirstResponder()
                        }
                        break
                    }
                }
            }
        }
    }
    
}

// MARK: - Adding views
extension NoteViewController {
    private func addTextView(with contentViewModel: ContentViewModel) {
        let textView = UITextView()
        textView.textColor = .white
        textView.delegate = self
        textView.backgroundColor = Constants.Colors.backgroudColor
        textView.font = UIFont.preferredFont(forTextStyle: .body).withSize(15)
        textView.isScrollEnabled = false
        textView.text = contentViewModel.data as? String
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { [weak self] make in
            make.leading.equalToSuperview().offset(17).priority(999)
            make.trailing.equalToSuperview().offset(-17).priority(999)
            make.width.equalTo(view.bounds.width - 34).priority(1000)
            if contentViewModel == content.first {
                make.top.equalTo(dateLabel.snp.bottom).offset(5)
                textView.tag = 1
            } else {
                for index in (0..<content.count).reversed() {
                    if content[index].type == .text && content[index] != contentViewModel {
                        textView.tag = contentViews[index].tag + 1
                        break
                    }
                }
                let previousIndex = content.firstIndex(of: contentViewModel)! - 1
                let previousView = contentViews[previousIndex]
                make.top.equalTo(previousView.snp.bottom).offset(5)
            }
            self?.lastViewBottomConstraint?.deactivate()
            self?.lastViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        contentViews.append(textView)
    }
    
}

// MARK: - View Input
extension NoteViewController: NoteViewInput {
    func update(with note: NoteViewModel) {
        titleTextView.text = note.title
        dateLabel.text = note.dateString
        titleTextViewPlaceholder.isHidden = note.title.count != 0
    }
}

// MARK: - Actions
extension NoteViewController {
    @objc private func didTapContentView() {
        for index in content.indices.reversed() {
            if content[index].type == .text {
                contentViews[index].becomeFirstResponder()
            }
        }
    }
}
