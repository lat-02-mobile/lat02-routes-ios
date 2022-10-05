//
//  Toast.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/10/22.
//

import Foundation
import UIKit

class Toast {
    static func showToast(target: UIViewController, message: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        target.view.addSubview(toastLabel)
        toastLabel.center = CGPoint(x: target.view.frame.size.width/2 - 75, y: target.view.frame.size.height - 100)
        toastLabel.trailingAnchor.constraint(equalTo: target.view.trailingAnchor, constant: -20).isActive = true
        toastLabel.leadingAnchor.constraint(equalTo: target.view.leadingAnchor, constant: 20).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: target.view.bottomAnchor, constant: -20).isActive = true
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
