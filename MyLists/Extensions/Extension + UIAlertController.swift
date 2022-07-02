//
//  Extension + UIAlertController.swift
//  MyLists
//
//  Created by катя on 01.07.2022.
//

import UIKit

extension UIAlertController {
    
    static func createAlertController(title: String) -> UIAlertController {
        UIAlertController(title: title, message: "Введите данные", preferredStyle: .alert)
    }
    
    func action(client: Client?, completion: @escaping (String, String) -> Void) {
        let saveAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let newName = self.textFields?.first?.text else { return }
            guard let newCash = self.textFields?.last?.text else { return }
            guard !newName.isEmpty else { return }
            guard !newCash.isEmpty else { return }
            completion(newName, newCash)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Name"
            textField.text = client?.name
        }
        addTextField { textField in
            textField.placeholder = "Cash"
            textField.text = client?.cash
        }
    }
}
