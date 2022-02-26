//
//  AlertViewer.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/24/22.
//

import UIKit

class AlertViewer {
    static func presentAlert(title: String, description: String, textFieldPlaceholders placeholders: [String], buttons: [UIAlertAction], on view: UIViewController) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        for placeholder in placeholders {
            alert.addTextField(configurationHandler: {$0.placeholder = placeholder})
        }
        for action in buttons {
            alert.addAction(action)
        }
        
        view.present(alert, animated: true, completion: nil)
    }
}

