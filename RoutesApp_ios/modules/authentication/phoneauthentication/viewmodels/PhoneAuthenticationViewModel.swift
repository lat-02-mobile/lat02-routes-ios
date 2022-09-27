import Foundation

class PhoneAuthenticationViewModel: ViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    private var verificationId = ""
    private var phoneNumber = ""
    var submittedPhoneNumberCode = { () -> Void in}
    var phoneNumberVerified = { () -> Void in}
    var onCodeVerficationError: ((String) -> Void)?
    var codeVerified: Bool = false {
        didSet {
            phoneNumberVerified()
        }
    }
    var codeSubmitted: Bool = false {
        didSet {
            submittedPhoneNumberCode()
        }
    }
    func verifyPhoneNumber(countryCode: String, phoneNumber: String) {
        guard countryCode != ""  else {
            onError?(String.localizeString(localizedString: "error-phoneauthentication-no-country-code"))
            return
        }
        guard phoneNumber != ""  else {
            onError?(String.localizeString(localizedString: "error-phoneauthentication-no-phone-number"))
            return
        }
        self.phoneNumber = countryCode + phoneNumber
        self.sendCodePhoneNumber()
    }
    func sendCodePhoneNumber() {
        authManager.sendPhoneNumberCode(phoneNumber: phoneNumber) { result in
            switch result {
            case .success(let verificationId):
                self.verificationId = verificationId
                self.codeSubmitted = true
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
     func verifyCodeNumber(code: String) {
         authManager.verifyPhoneNumber(currentVerificationId: verificationId, code: code) { result in
             switch result {
             case .success:
                 self.codeVerified = true
             case .failure(let error):
                 let codeError: NSError = error as NSError
                 switch codeError.code {
                 case 17025:
                     self.onCodeVerficationError?(String.localizeString(localizedString: "error-code-verification-alert-already-linked"))
                 case 17044:
                     self.onCodeVerficationError?(String.localizeString(localizedString: "error-codeverification"))
                 default:
                     self.onCodeVerficationError?(String.localizeString(localizedString: "error-unknown"))
                 }
             }
         }
     }
}
