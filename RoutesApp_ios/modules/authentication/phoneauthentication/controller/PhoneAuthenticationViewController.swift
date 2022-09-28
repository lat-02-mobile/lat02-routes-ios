import UIKit
import CountryPicker
import SVProgressHUD
import SwiftAlertView

class PhoneAuthenticationViewController: UIViewController {
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryPicker: CountryPicker!
    @IBOutlet weak var errorLabel: UILabel!
    private let viewmodel = PhoneAuthenticationViewModel()
    private var alertView = SwiftAlertView()
    private var codeResend = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? "+1"
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry(code)
        initViewModel()
        initAlertView()
    }
    func initAlertView() {
        let title = String.localizeString(localizedString: "code-verification-alert-title")
        let buttonTitles: [String] = [
            String.localizeString(localizedString: "code-verification-alert-verify"),
            String.localizeString(localizedString: "code-verification-alert-Resend"),
            String.localizeString(localizedString: "code-verification-alert-cancel")
        ]
        alertView = SwiftAlertView(title: title, buttonTitles: buttonTitles)
        alertView.addTextField { textField in
            textField.placeholder = String.localizeString(localizedString: "code")
            textField.keyboardType = .numberPad
        }
        alertView.isEnabledValidationLabel = true
        alertView.isDismissOnActionButtonClicked = false
        alertView.cancelButtonIndex = 2
        alertView.validationLabelTopMargin = CGFloat(15)
        alertView.validationLabelSideMargin = CGFloat(15)
        alertView.onButtonClicked { alertView, buttonIndex in
            switch buttonIndex {
            case 0:
                let code = alertView.textField(at: 0)?.text ?? ""
                if  code.isEmpty {
                    alertView.validationLabel.text = String.localizeString(localizedString: "error-codeverification-no-code-enter")
                } else {
                    self.viewmodel.verifyCodeNumber(code: code)
                }
            case 1:
                self.viewmodel.sendCodePhoneNumber()
                self.codeResend = true
            case 2:
                alertView.dismiss()
                self.codeResend = false
                alertView.validationLabel.text = ""
            default:
                alertView.validationLabel.text = String.localizeString(localizedString: "error-unknown")
            }
        }
    }

    func initViewModel() {
        viewmodel.onError = { [weak self] error in
            SVProgressHUD.dismiss()
            self?.errorLabel.isHidden = false
            self?.errorLabel.text = error
        }
        viewmodel.submittedPhoneNumberCode = { [weak self] () in
            SVProgressHUD.dismiss()
            self?.errorLabel.isHidden = true
            if self?.viewmodel.codeSubmitted == true, self?.codeResend == false {
                self?.alertView.show()
            } else {
                self?.alertView.validationLabel.text = String.localizeString(localizedString: "code-forwarded-codeverification")
            }
        }
        viewmodel.onCodeVerficationError = { [weak self] error in
            self?.alertView.validationLabel.text = error
        }
        viewmodel.phoneNumberVerified = {[weak self] () in
            self?.alertView.dismiss()
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func sendPhoneNumber(_ sender: Any) {
        SVProgressHUD.show()
        guard let countryCode = codeTextField.text,
              let phoneNumber = phoneNumberTextField.text
              else { return }
        viewmodel.verifyPhoneNumber(countryCode: countryCode, phoneNumber: phoneNumber)
    }
}

extension PhoneAuthenticationViewController: CountryPickerDelegate {
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        codeTextField.text = phoneCode
       }
}
