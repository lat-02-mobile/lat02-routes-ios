//
//  LineEditModeViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 24/10/22.
//

import UIKit

class LineEditModeViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Someting"
        // Do any additional setup after loading the view.
    }

    @IBAction func saveLine(_ sender: Any) {
    }
}
