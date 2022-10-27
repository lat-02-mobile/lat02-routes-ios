//
//  ConfirmAlert.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 26/10/22.
//

import UIKit

class ConfirmAlert: UIAlertController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAction(UIAlertAction(title: "No", style: .cancel))
    }

    func showAlert(target: UIViewController, onConfirm: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            onConfirm()
        })
        target.navigationController?.present(self, animated: true)
    }
}
