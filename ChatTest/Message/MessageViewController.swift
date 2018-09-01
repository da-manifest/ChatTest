//
//  MessageViewController.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let title = "Message Details"
    static let nibName = "TagCell"
    static let cellID = "cell"
    static let cellHeight: CGFloat = 50
}

final class MessageViewController: UIViewController {
    
    // MARK: - Variables
    var messageID: Int?
    private var message: Message?
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: Constants.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        if let id = messageID { loadMessageWith(id: id) }
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        title = Constants.title
        label.text = message?.text
        label.numberOfLines = 0
        dateLabel.text = message?.dateCreated
    }
    
    // MARK: - Actions
    private func loadMessageWith(id: Int) {
        _ = DS24Service.getMessageDetails(id: id)
            .subscribe(onNext: { [weak self] message in
            self?.message = message
                DispatchQueue.main.async { [weak self] in
                    self?.configureUI()
                    self?.collectionView.reloadData()
                }
            
            }, onError: { [weak self] error in
                self?.showError(error)
        })
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return message?.tagList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID,
                                                      for: indexPath) as! TagCell
        if let tag = message?.tagList?[indexPath.row] {
            cell.setLabel(tag.label)
            if let color = tag.color { cell.setColor(color) }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let tagText = message?.tagList?[indexPath.row].label {
            let height: CGFloat = Constants.cellHeight
            let width = tagText.width(withConstrainedHeight: height,
                                      font: .systemFont(ofSize: height / 2))
            return CGSize(width: width, height: height)
        }
        return .zero
    }
}
