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

    func firebaseSocialMediaSignIn(with credential: NSObject, completion: @escaping (Result<NSObject?, Error>) -> Void) {
        if !isValidCredential {
            completion(.failure(NSError(domain: "Error", code: 0)))
            return
        }
        completion(.success(NSObject()))
    }

    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        if password.count > 5 && !email.isEmpty {
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

class AuthTests: XCTestCase {
    var signupViewmodel = SignupViewModel()
    override func setUpWithError() throws {
        signupViewmodel.authManager = MockAuthManager()
        signupViewmodel.userManager = MockUserManager()
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
    // MARK: Google Signin Tests
    func testGoogleSignValidToken() {
        let authManager = signupViewmodel.authManager as? MockAuthManager ?? MockAuthManager()
        authManager.isValidToken = true
        authManager.signInWithGoogle(target: UIViewController()) { result in
            switch result {
            case .success:
                XCTAssertTrue(authManager.isValidCredential)
            case .failure:
                XCTAssertFalse(authManager.isValidCredential)
            }
        }
    }

    func testGoogleSignInValidToken() {
        let authManager = signupViewmodel.authManager as? MockAuthManager ?? MockAuthManager()
        authManager.isValidToken = false
        authManager.signInWithGoogle(target: UIViewController()) { result in
            switch result {
            case .success:
                XCTAssertTrue(authManager.isValidCredential)
            case .failure:
                XCTAssertFalse(authManager.isValidCredential)
            }
        }
    }

    func testFirebaseValidCredential() {
        let authManager = signupViewmodel.authManager as? MockAuthManager ?? MockAuthManager()
        authManager.isValidToken = false
        authManager.firebaseSocialMediaSignIn(with: NSObject()) { result in
            switch result {
            case .success(let authUser):
                XCTAssertNotNil(authUser)
            case .failure:
                XCTAssertFalse(authManager.isValidCredential)
            }
        }
    }

    func testFirebaseInValidCredential() {
        let authManager = signupViewmodel.authManager as? MockAuthManager ?? MockAuthManager()
        authManager.isValidToken = false
        authManager.firebaseSocialMediaSignIn(with: NSObject()) { result in
            switch result {
            case .success(let authUser):
                XCTAssertNotNil(authUser)
            case .failure:
                XCTAssertFalse(authManager.isValidCredential)
            }
        }
    }
}
