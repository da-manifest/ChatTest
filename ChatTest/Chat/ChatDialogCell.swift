//
//  ChatDialogCell.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import UIKit

final class ChatDialogCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        label.numberOfLines = 0
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
    }
    
    // MARK: - Actions
    func isLeftSide(_ isLeftSide: Bool) {
        leadingConstraint.constant = isLeftSide ? 8 : 100
        trailingConstraint.constant = isLeftSide ? 100 : 8
    }
}
