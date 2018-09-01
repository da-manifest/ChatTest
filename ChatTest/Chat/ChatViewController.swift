//
//  ChatViewController.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let title = "Messages"
    static let nibName = "ChatDialogCell"
    static let cellID = "cell"
    static let segueID = "showMessage"
    static let tableViewActivityIndicatorHeight: CGFloat = 44
}

final class ChatViewController: UIViewController {
    
    // MARK: - Variables
    private var messages = [Message]()
    private var selectedMessageID = 0
    private var isFinishedLoadingMessages = false
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: Constants.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        configureUI()
        loadMessages()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        title = Constants.title
    }
    
    // MARK: - Actions
    private func loadMessages(offset: Int = 1) {
        showTableViewActivityIndicator()
        _ = DS24Service.getMessages(offset: offset).subscribe(onNext: { [weak self] result in
            self?.hideTableViewActivityIndicator()
            self?.isFinishedLoadingMessages = result.isEmpty
            result.forEach{ self?.messages.append($0) }
            DispatchQueue.main.async{ self?.tableView.reloadData() }
            }, onError: { [weak self] error in
                self?.hideTableViewActivityIndicator()
                self?.showError(error)
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueID {
            if let vc = segue.destination as? MessageViewController {
                vc.messageID = selectedMessageID
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID,
                                                 for: indexPath) as! ChatDialogCell
        let message = messages[indexPath.row]
        cell.label.text = message.text
        cell.isLeftSide(message.isLeftSide)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastElement = indexPath.row == messages.count - 1
        
        if isLastElement && !isFinishedLoadingMessages {
            loadMessages(offset: messages.count + 1)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessageID = messages[indexPath.row].id
        performSegue(withIdentifier: Constants.segueID, sender: self)
    }
}

// MARK: - TableView Activity Indicator
private extension ChatViewController {
    
    func showTableViewActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0,
                                         width: tableView.bounds.width,
                                         height: Constants.tableViewActivityIndicatorHeight)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = activityIndicator
        }
    }
    
    func hideTableViewActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = nil
        }
    }
}
