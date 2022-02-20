//
//  NoteNoteViewController.swift
//  ImprovedNotes
//
//  Created by AlexStyx on 21/01/2022.
//  Copyright © 2022 Cyberia. All rights reserved.
//

import UIKit

final class NoteViewController: UIViewController {
    
    var output: NoteViewOutput?
    var viewReadyBlock: (() -> Void)?
    
    private lazy var content = [ContentViewModel]()
    
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
    
    // MARK: - UI
    
    private let scrollView =  UIScrollView()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.backgroudColor
        return view
    }()
    private lazy var titleTextField: UITextView = {
        let textField = UITextView()
        textField.textColor = .white
        textField.backgroundColor = Constants.Colors.backgroudColor
        textField.isScrollEnabled = false
        textField.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return textField
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.text = "30.01.2022"
        return label
    }()
    
    let titleTextViewPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Note title"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        label.alpha = 0.5
        return label
    }()
    
    private var contentViews = [UIView]()
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
            titleTextField,
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
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-17)
        }
        
        titleTextViewPlaceholder.snp.makeConstraints { make in
            make.leading.equalTo(titleTextField).offset(5)
            make.centerY.equalTo(titleTextField)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupTitleTextView() {
        titleTextField.delegate = self

    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        titleTextViewPlaceholder.isHidden = !text.isEmpty
    }
}

// MARK: - Adding views
extension NoteViewController {
    private func addTextView(with contentViewModel: ContentViewModel) {
        let textView = UITextView()
        textView.textColor = .systemGray6
        textView.backgroundColor = Constants.Colors.backgroudColor
        contentViews.append(textView)
        textView.isScrollEnabled = false
        if let contentData = contentViewModel.data {
            textView.text = String(data: contentData, encoding: .utf8)
        }
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-17)
            if contentViewModel == content.first {
                make.top.equalTo(dateLabel.snp.bottom).offset(5)
            } else {
                let previousIndex = content.firstIndex(of: contentViewModel)! - 1
                let previousView = contentViews[previousIndex]
                make.top.equalTo(previousView).offset(5)
            }
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - View Input
extension NoteViewController: NoteViewInput {
    
}

