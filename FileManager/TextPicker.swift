//
//  TextPicker.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 5.08.24.
//

import Foundation
import UIKit

final class TextPicker {
    static func showAddFolder(in viewController: UIViewController, completion: @escaping ((_ text: String) -> Void)) {
        let alert = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter title"
        }
        
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alert.textFields?[0].text {
                completion(text)
            }
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAlertAction)
        alert.addAction(cancelAlertAction)
        
        viewController.present(alert, animated: true)
    }
}
