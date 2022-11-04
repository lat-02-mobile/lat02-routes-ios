//
//  CityEditModeViewController.swift
//  RoutesApp_ios
//
//  Created by user on 3/11/22.
//

import UIKit
import SVProgressHUD

class CityEditModeViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var latitudeTextField: UITextField!

    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var longitudeTextField: UITextField!

    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var countryPicker: UIPickerView!

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveEditButton: UIButton!

    let viewmodel = CityViewModel()
    let countryViewmodel = CountryViewModel()
    var city: Cities

    init(city: Cities) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.city = Cities(country: "", id: "", idCountry: "", lat: "", lng: "", name: "")
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initViewModels()
        setupCountryPicker()
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func saveEditAction(_ sender: Any) {
        let selectedCountry = countryViewmodel.countries[countryPicker.selectedRow(inComponent: 0)]
        guard let name = nameTextField.text,
              let latitude = latitudeTextField.text,
              let lat = Double(latitude),
              isValidLatitude(latitude: lat),
              let longitude = longitudeTextField.text,
              let lng = Double(longitude),
              isValidLongitude(longitude: lng) else { return }
        let idCountry = selectedCountry.id
        let countryName = selectedCountry.name

        if city.id.isEmpty {
            viewmodel.createCity(name: name, latitude: latitude, longitude: longitude, country: countryName, idCountry: idCountry) { result in
                switch result {
                case .success:
                    Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.adminCityCreatedSuccess))
                    self.navigationController?.popViewController(animated: true)
                case .failure:
                    Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.adminCityCreatedError))
                }
            }
            return
        }
        viewmodel.updateCity(id: city.id, name: name, latitude: latitude, longitude: longitude, country: countryName,
                             idCountry: idCountry) { result in
            switch result {
            case .success:
                Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.adminCityEditedSuccess))
                self.navigationController?.popViewController(animated: true)
            case .failure:
                Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.adminCityCreatedError))
            }
        }
    }

    func setupCountryPicker() {
        countryViewmodel.getCountries()
    }

    func setupViews() {
        nameTextField.text = city.name
        latitudeTextField.text = city.lat
        longitudeTextField.text = city.lng
        countryPicker.delegate = self
        countryPicker.dataSource = self
        saveEditButton.titleLabel?.text =  city.id.isEmpty
        ? String.localizeString(localizedString: StringResources.adminCitySaveButton)
        : String.localizeString(localizedString: StringResources.adminCityEditButton)

        let removeIcon = UIImage(systemName: ConstantVariables.trashIcon)?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let removeButton = UIBarButtonItem(image: removeIcon, style: .plain, target: self, action: #selector(removeCity))
        navigationItem.rightBarButtonItem = removeButton
    }

    @objc func removeCity() {
        ConfirmAlert(title: String.localizeString(localizedString: StringResources.adminCityDelete),
                     message: String.localizeString(localizedString: StringResources.adminCityDeleteMessage),
                     preferredStyle: .alert).showAlert(target: self) { () in
            SVProgressHUD.show()
            self.viewmodel.removeCity(city: self.city) {_ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func initViewModels() {
        SVProgressHUD.show()
        let onFinish = {
            SVProgressHUD.dismiss()
        }
        viewmodel.onFinish = onFinish
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }

        countryViewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.countryPicker.reloadAllComponents()
            if let indexCountry = strongSelf.countryViewmodel.countries.firstIndex(where: ({$0.id ==
                strongSelf.city.idCountry})) {
                DispatchQueue.main.async {
                    strongSelf.countryPicker.selectRow(indexCountry, inComponent: 0, animated: true)
                }
            }
            SVProgressHUD.dismiss()
        }
        countryViewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }

    private func isValidLatitude(latitude: Double) -> Bool {
        return latitude >= -90 && latitude <= 90
    }

    private func isValidLongitude(longitude: Double) -> Bool {
        return longitude >= -180 && longitude <= 180
    }
}

extension CityEditModeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countryViewmodel.countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        countryViewmodel.countries[row].name
    }
}
