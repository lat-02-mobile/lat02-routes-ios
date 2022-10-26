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
    @IBOutlet weak var enableLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!
    let viewmodel = LineEditModeViewModel()
    var targetLine: Lines?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupViews()
    }

    @IBAction func saveLine(_ sender: Any) {
        guard let currLine = targetLine else {
            ConfirmAlert(title: "Edit Line",
                         message: "Are you sure you want to update this line?",
                         preferredStyle: .alert).showAlert(target: self) { () in
                if let name = self.nameTextField.text {
                    self.viewmodel.createNewLine(newLineName: name,
                                                 idCategory: self.viewmodel.categories[self.categoryPicker.selectedRow(inComponent: 0)].id,
                                                 idCity: self.viewmodel.cities[self.cityPicker.selectedRow(inComponent: 0)].id)
                }
            }
            return
        }

        ConfirmAlert(title: "Create new Line",
                     message: "Are you sure you want to create a new Line with these paremeters?",
                     preferredStyle: .alert).showAlert(target: self) { () in
            if let name = self.nameTextField.text {
                self.viewmodel.editLine(targetLine: currLine,
                                        newLineName: name,
                                        newIdCategory: self.viewmodel.categories[self.categoryPicker.selectedRow(inComponent: 0)].id,
                                        newIdCity: self.viewmodel.cities[self.cityPicker.selectedRow(inComponent: 0)].id,
                                        newEnable: self.enableSwitch.isOn)
            }
        }
    }

    func setupViews() {
        enableLabel.text = "Disable"
        enableSwitch.setOn(false, animated: true)
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        cityPicker.delegate = self
        cityPicker.dataSource = self
        enableSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        let removeIcon = UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let removeButton = UIBarButtonItem(image: removeIcon, style: .plain, target: self, action: #selector(removeLine))
        if let line = targetLine {
            saveButton.setTitle("Update", for: .normal)
            nameTextField.text = line.name
            enableLabel.text = line.enable ? "Enable" : "Disable"
            enableSwitch.setOn(line.enable, animated: true)
            navigationItem.rightBarButtonItem = removeButton
        }
    }

    @objc func removeLine() {
        viewmodel.deleteLine(idLine: targetLine?.id ?? "")
    }

    @objc func switchChanged() {
        if enableSwitch.isOn {
            enableLabel.text = "Enable"
        } else {
            enableLabel.text = "Disable"
        }
    }

    func initViewModel() {
        viewmodel.onFinish = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        viewmodel.onFinishCategories = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.categoryPicker.reloadAllComponents()
            if strongSelf.targetLine != nil {
                if let indexCategory = strongSelf.viewmodel.categories.firstIndex(where: ({$0.id == strongSelf.targetLine?.idCategory})) {
                    DispatchQueue.main.async {
                        strongSelf.categoryPicker.selectRow(indexCategory, inComponent: 0, animated: true)
                    }
                }
            }
        }
        viewmodel.onFinishCities = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.cityPicker.reloadAllComponents()
            if strongSelf.targetLine != nil {
                if let indexCity = strongSelf.viewmodel.cities.firstIndex(where: ({$0.id == strongSelf.targetLine?.idCity})) {
                    DispatchQueue.main.async {
                        strongSelf.cityPicker.selectRow(indexCity, inComponent: 0, animated: true)
                    }
                }
            }
        }
        viewmodel.onError = { error in
            ErrorAlert.shared.showAlert(title: "Something went wrong", message: error, target: self)
        }
        viewmodel.getCategories()
        viewmodel.getCities()
    }
}

extension LineEditModeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case categoryPicker:
            return viewmodel.categories.count
        case cityPicker:
            return viewmodel.cities.count
        default:
            print("something wrong")
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case categoryPicker:
            return viewmodel.categories[row].nameEng
        case cityPicker:
            return viewmodel.cities[row].name
        default:
            print("something wrong")
        }
        return ""
    }
}
