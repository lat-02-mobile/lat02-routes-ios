//
//  LineRouteEditModeViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 31/10/22.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

class LineRouteEditModeViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var avgVelocityTextField: UITextField!
    @IBOutlet weak var colorPreviewView: UIView!
    @IBOutlet weak var finishButton: UIButton!

    let line: Lines
    var currLineRoute: LineRouteInfo?
    let viewmodel = LineRouteEditModeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initViewModel()
    }

    init(line: Lines, targetLineRoute: LineRouteInfo? = nil) {
        self.line = line
        self.currLineRoute = targetLineRoute
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @IBAction func chooseColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func finish(_ sender: Any) {
        guard let name = nameTextField.text, let avgVel = avgVelocityTextField.text else {return}
        SVProgressHUD.show()
        if let targetLineRoute = currLineRoute {
            viewmodel.editLineRoute(targetLineRoute: targetLineRoute, newName: name,
                                    newAvgVel: avgVel,
                                    newColor: colorPreviewView.backgroundColor?.toHexString() ?? ConstantVariables.primaryColorHexValue,
                                    newRoutePoitns: targetLineRoute.routePoints,
                                    newStops: targetLineRoute.stops,
                                    newStart: targetLineRoute.start, newEnd: targetLineRoute.end)
        } else {
            guard let dummyLat = viewmodel.cityCoords?.latitude,
                  let dummyLng = viewmodel.cityCoords?.longitude else { return }
            let dummyStart = GeoPoint(latitude: dummyLat, longitude: dummyLng)
            let dummyEnd = GeoPoint(latitude: dummyLat, longitude: dummyLng)
            viewmodel.createLineRoute(name: name, avgVel: avgVel,
                                      color: colorPreviewView.backgroundColor?.toHexString() ?? ConstantVariables.primaryColorHexValue,
                                      start: dummyStart, end: dummyEnd, routePoints: [GeoPoint](), stops: [GeoPoint]())
        }
    }

    func initViewModel() {
        viewmodel.currLine = line
        viewmodel.onFinishGetCityCoords = { [weak self] in
            self?.finishButton.isEnabled = true
        }
        viewmodel.onFinish = { [weak self] in
            SVProgressHUD.dismiss()
            self?.navigationController?.popViewController(animated: true)
        }
        viewmodel.onError = { error in
            SVProgressHUD.dismiss()
            ErrorAlert.shared.showAlert(title: String.localizeString(localizedString: StringResources.adminLinesSomethingWrong),
                                        message: error,
                                        target: self)
        }
        viewmodel.getCityCoords()
    }

    func setupViews() {
        finishButton.isEnabled = false
        let removeIcon = UIImage(systemName: ConstantVariables.trashIcon)?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let removeButton = UIBarButtonItem(image: removeIcon, style: .plain, target: self, action: #selector(removeLineRoute))
        colorPreviewView.backgroundColor = UIColor(named: ConstantVariables.primaryColor)
        title = String.localizeString(localizedString: StringResources.adminLineRoutesNew)
        if let targetLineRoute = currLineRoute {
            title = targetLineRoute.name
            navigationItem.rightBarButtonItem = removeButton
            nameTextField.text = targetLineRoute.name
            avgVelocityTextField.text = targetLineRoute.averageVelocity
            colorPreviewView.backgroundColor = UIColor.hexStringToUIColor(hex: targetLineRoute.color)
        }
    }

    @objc func removeLineRoute() {
        ConfirmAlert(title: String.localizeString(localizedString: StringResources.adminLineRoutesDelete),
                     message: String.localizeString(localizedString: StringResources.adminLineRoutesDeleteMessage),
                     preferredStyle: .alert).showAlert(target: self) { () in
            SVProgressHUD.show()
            self.viewmodel.deleteLineRoute(idLineRoute: self.currLineRoute?.id ?? "")
        }
    }
}

extension LineRouteEditModeViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorPreviewView.backgroundColor = viewController.selectedColor
    }
}
