//
//  TagCell.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        label.numberOfLines = 1
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
    }
    
    // MARK: - Actions
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }

    func setLabel(_ text: String) {
        label.text = text
    }
}
