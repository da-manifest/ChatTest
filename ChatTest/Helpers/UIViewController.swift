//
//  UIViewController.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let alertTitle = "Error"
    static let ok = "OK"
}

extension UIViewController {
    
    func showError(_ error: Error) {
        
        let alertMessage = APIError.description(error)
        let alertViewController = UIAlertController(title: Constants.alertTitle,
                                                    message: alertMessage,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.ok, style: .default) { _ in
            alertViewController.dismiss(animated: true)
        }
        alertViewController.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertViewController, animated: true)
        }
    }
}
