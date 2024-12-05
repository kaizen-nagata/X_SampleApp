//
//  CustomTableViewCell.swift
//  X_SampleApp
//
//  Created by r.nagata on 2024/11/26.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameViewField: UILabel!
    @IBOutlet weak var timestampViewField: UILabel!
    @IBOutlet weak var contentViewField: UITextView!
    @IBOutlet weak var optionsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentViewField.isEditable = false
        contentViewField.isSelectable = false
    }
    
    @IBAction func tappedOptionsButton(_ sender: UIButton) {
        if let parentViewController = self.parentViewController() as? TimeLineViewController {
            parentViewController.showOptions(for: self)
        }
    }

    // 親ビューコントローラを取得する補助メソッド
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
