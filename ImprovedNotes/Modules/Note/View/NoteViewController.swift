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
        view.backgroundColor = .orange
        output?.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public
    func setupViewReadyBlock(block: @escaping () -> Void) {
        viewReadyBlock = block;
    }

    // MARK: - Private

}


// MARK: - View Input
extension NoteViewController: NoteViewInput {
    
}
