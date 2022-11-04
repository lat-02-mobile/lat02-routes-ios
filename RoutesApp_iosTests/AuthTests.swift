//
//  AuthTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 9/8/22.
//

import XCTest
import FirebaseAuth
@testable import RoutesApp_ios

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
        signupViewmodel.signupUser(email: "email111@email.com", name: "john", password: "test1234", confirmPassword: "test1234")
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
