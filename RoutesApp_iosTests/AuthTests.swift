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
}

class LoginAuthTests: XCTestCase {
    var loginViewmodel = MockLoginViewModel()
    override func setUpWithError() throws {
        loginViewmodel.authManager = MockAuthManager()
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
