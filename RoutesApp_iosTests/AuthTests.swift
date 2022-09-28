//
//  AuthTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 9/8/22.
//

import XCTest
import FirebaseAuth
@testable import RoutesApp_ios

class MockAuthManager: AuthProtocol {
    var isValidToken = false
    var isValidCredential = false
    func signInWithGoogle(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void) {
        if !isValidToken {
            isValidCredential = false
            completion(.failure(NSError(domain: "Error", code: 0)))
            return
        }
        isValidCredential = true
        completion(.success((NSObject(), "mockemail@gmail.com")))
    }

    func signInWithFacebook(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void) {
        if !isValidToken {
            isValidCredential = false
            completion(.failure(NSError(domain: "Error", code: 0)))
            return
        }
        isValidCredential = true
        completion(.success((NSObject(), "mockemail@facebook.com")))
    }

    func firebaseSocialMediaSignIn(with credential: NSObject, completion: @escaping (Result<NSObject?, Error>) -> Void) {
        if !isValidCredential {
            completion(.failure(NSError(domain: "Error", code: 0)))
            return
        }
        completion(.success(NSObject()))
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        if email == TestResources.testUserEmail, password == TestResources.testUserPassword {
            completion(.success(nil))
        } else {
            completion(.failure(NSError(domain: "Error", code: 1)))
        }
    }
    func logout() -> Bool {
        return true
    }
    func userIsLoggedIn() -> Bool {
        return true
    }
    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        if password.count > 5 && !email.isEmpty {
            completion(.success(nil))
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }
    func sendPhoneNumberCode(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        if phoneNumber.count < 16, phoneNumber.first == "+"{
            completion(.success(""))
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }
    func verifyPhoneNumber(currentVerificationId: String, code: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        if currentVerificationId.count > 5, code.count == 4 {
            completion(.success(nil))
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }
}
class MockUserManager: UserManProtocol {
    var registerUserGotCalled = false
    var getUsersGotCalled = false
    func getUsers(completion: @escaping (Result<[UserManResult], Error>) -> Void) {
        getUsersGotCalled = true
        completion(.success([TestResources.testUser]))
    }
    func registerUser(name: String, email: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<UserManResult, Error>) -> Void)) {
        registerUserGotCalled = true
        completion(.success(TestResources.testUser))
    }
}

class MockLoginViewModel: LoginViewModel {
    var onFinishGotCalled = false
}

class SignupAuthTests: XCTestCase {
    var signupViewmodel = SignupViewModel()
    var authManager = MockAuthManager()
    override func setUpWithError() throws {
        signupViewmodel.authManager = MockAuthManager()
        signupViewmodel.userManager = MockUserManager()
        authManager = signupViewmodel.authManager as? MockAuthManager ?? MockAuthManager()
    }
    func testSignupSuccess() {
        signupViewmodel.signupUser(email: "john@doe.com", name: "john", password: "test1234", confirmPassword: "test1234")
        XCTAssert((signupViewmodel.userManager as? MockUserManager ?? MockUserManager()).registerUserGotCalled == true)
    }
    func testSignupFailureDueMissmatchPasswords() {
        signupViewmodel.signupUser(email: "john@doe.com", name: "john", password: "test1234", confirmPassword: "test")
        XCTAssert((signupViewmodel.userManager as? MockUserManager ?? MockUserManager()).registerUserGotCalled == false)
    }
    func testSignupFailureDueEmptyName() {
        signupViewmodel.signupUser(email: "john@doe.com", name: "", password: "test1234", confirmPassword: "test1234")
        XCTAssert((signupViewmodel.userManager as? MockUserManager ?? MockUserManager()).registerUserGotCalled == false)
    }
    func testSignupFailureDueExistingUser() {
        signupViewmodel.signupUser(email: "test@email.com", name: "john", password: "test1234", confirmPassword: "test1234")
        XCTAssert((signupViewmodel.userManager as? MockUserManager ?? MockUserManager()).registerUserGotCalled == false)
    }
    func testSignupFailureDueEmptyEmail() {
        signupViewmodel.signupUser(email: "", name: "john", password: "test1234", confirmPassword: "test1234")
        XCTAssert((signupViewmodel.userManager as? MockUserManager ?? MockUserManager()).registerUserGotCalled == false)
    }
    func testSignupFailureDueWeakPassword() {
        signupViewmodel.signupUser(email: "john@doe.com", name: "john", password: "test", confirmPassword: "test")
        XCTAssert((signupViewmodel.userManager as? MockUserManager ?? MockUserManager()).registerUserGotCalled == false)
    }
    // MARK: Phone authentication  Tests
    func testSendPhoneNumberCode() {
        authManager.sendPhoneNumberCode( phoneNumber: TestResources.testPhoneNumber ) { result in
            switch result {
            case .success(let result):
                XCTAssertEqual(result, "")
            case .failure(let result):
                XCTAssertNotNil(result)
            }
        }
    }
    func testVerifyPhoneNumber() {
        authManager.verifyPhoneNumber(currentVerificationId: TestResources.verificationId, code: TestResources.testCode) { result in
            switch result {
            case .success(let result):
               XCTAssertNil(result)
            case .failure(let result):
               XCTAssertNotNil(result)
            }
        }
    }
    // MARK: Google Signin Tests
    func testGoogleSignValidToken() {
        authManager.isValidToken = false
        authManager.signInWithGoogle(target: UIViewController()) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.authManager.isValidCredential)
            case .failure:
                XCTAssertFalse(self.authManager.isValidCredential)
            }
        }
    }

    func testGoogleSignInValidToken() {
        authManager.isValidToken = false
        authManager.signInWithGoogle(target: UIViewController()) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.authManager.isValidCredential)
            case .failure:
                XCTAssertFalse(self.authManager.isValidCredential)
            }
        }
    }

    // MARK: Facebook
    func testFacebookSignValidToken() {
        authManager.isValidToken = true
        authManager.signInWithFacebook(target: UIViewController()) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.authManager.isValidCredential)
            case .failure:
                XCTAssertFalse(self.authManager.isValidCredential)
            }
        }
    }

    func testFacebookSignInValidToken() {
        authManager.isValidToken = false
        authManager.signInWithFacebook(target: UIViewController()) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.authManager.isValidCredential)
            case .failure:
                XCTAssertFalse(self.authManager.isValidCredential)
            }
        }
    }

    func testFirebaseValidCredential() {
        authManager.isValidToken = false
        authManager.firebaseSocialMediaSignIn(with: NSObject()) { result in
            switch result {
            case .success(let authUser):
                XCTAssertNotNil(authUser)
            case .failure:
                XCTAssertFalse(self.authManager.isValidCredential)
            }
        }
    }

    func testFirebaseInValidCredential() {
        authManager.isValidToken = false
        authManager.firebaseSocialMediaSignIn(with: NSObject()) { result in
            switch result {
            case .success(let authUser):
                XCTAssertNotNil(authUser)
            case .failure:
                XCTAssertFalse(self.authManager.isValidCredential)
            }
        }
    }
}

class LoginAuthTests: XCTestCase {
    var loginViewmodel = MockLoginViewModel()
    override func setUpWithError() throws {
        loginViewmodel.authManager = MockAuthManager()
        loginViewmodel.userManager = MockUserManager()
        loginViewmodel.onFinish = {
            self.loginViewmodel.onFinishGotCalled = true
        }
    }
    func testLoginSuccess() {
        loginViewmodel.loginUser(email: "john@doe.com", password: "test1234")
        XCTAssert(loginViewmodel.onFinishGotCalled == true)
    }
    func testLoginFailureDueWrongEmail() {
        loginViewmodel.loginUser(email: "doe@doe.com", password: "test1234")
        XCTAssert(loginViewmodel.onFinishGotCalled == false)
    }
    func testLoginFailureDueWrongPassword() {
        loginViewmodel.loginUser(email: "john@doe.com", password: "test4321")
        XCTAssert(loginViewmodel.onFinishGotCalled == false)
    }
}
