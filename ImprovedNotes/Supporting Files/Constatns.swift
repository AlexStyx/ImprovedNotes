//
//  Constatns.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 1/22/22.
//

import UIKit

enum Constants {
    enum Colors {
        static let backgroudColor = UIColor(named: "backgroudColor")
        static let buttonBackgroundColor = UIColor(named: "searchButtonBackgroundColor")
        static let detailViewBackgroundColor = UIColor(named: "detailViewsBackgroud")
    }
    
    enum Sizes {
        static let floatingButtonSideSize: CGFloat = 75
    }
    
    enum CoreData {
        static let modelName = "CoreDataModel"
    }
    
    enum Fonts {
        static let noteTitleFont = UIFont.systemFont(ofSize: 25, weight: .heavy)
        static let noteDateFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    enum Tags {
        static let noteTitleTextViewTag = 0
    }
}
