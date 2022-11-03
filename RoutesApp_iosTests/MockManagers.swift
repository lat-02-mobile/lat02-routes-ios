//
//  MockManagers.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 1/11/22.
//

import XCTest
import FirebaseAuth
@testable import GooglePlaces
@testable import RoutesApp_ios

// City Manager
class MockCityManager: CityManagerProtocol {
    var getCitiesByNameGotCalled = false
    var getCitiesGotCalled = false
    var getCityByIdGotCalled = false

    func getCityById(id: String, completion: @escaping (Result<Cities, Error>) -> Void) {
        guard let foundCity = TestResources.CitiesArray.filter({$0.id == id}).first else {return}
        getCityByIdGotCalled = true
        completion(.success(foundCity))
    }

    func getCitiesByName(parameter: String, completion: @escaping (Result<[Cities], Error>) -> Void) {
        if !parameter.isEmpty {
            completion(.success([TestResources.testCityRoute]))
            getCitiesByNameGotCalled = true
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
            getCitiesByNameGotCalled = false
        }
    }
    func getCountryById(id: String, completion: @escaping (Result<Country, Error>) -> Void) {
        if !id.isEmpty {
            completion(.success(TestResources.testCountry))
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }
    func getCities(completion: @escaping (Result<[Cities], Error>) -> Void) {
        completion(.success([TestResources.testCityRoute]))
        getCitiesGotCalled = true
    }
}

// Auth Manager
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

// User Manager
class MockUserManager: UserManProtocol {
    var registerUserGotCalled = false
    var getUsersGotCalled = false
    var toogleUserRoleGotCalled  = false
    func getUsers(completion: @escaping (Result<[UserManResult], Error>) -> Void) {
        getUsersGotCalled = true
        completion(.success([TestResources.testUser]))
    }
    func registerUser(name: String, email: String, uid: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<UserFirebase, Error>) -> Void)) {
        registerUserGotCalled = true
        completion(.success(TestResources.testUserFirebase1))
    }
    func getUsers(completion: @escaping (Result<[UserFirebase], Error>) -> Void) {
           getUsersGotCalled = true
        completion(.success(TestResources.testUserFirebaseList))
    }
    func toogleUserRole(user: UserFirebase, completion: @escaping (Result<Bool, Error>) -> Void) {
        toogleUserRoleGotCalled = true
        completion(.success(true))
    }
}

// Maps Manager
class MockGoogleMapsManager: GoogleMapsManagerProtocol {
    var findPlacesGotCalled = false
    var placeIdToLocationGotCalled = false
    func findPlaces(query: String, placeBias: GMSPlaceLocationBias, completion: @escaping (Result<[Place], Error>) -> Void) {
        if !query.isEmpty {
            completion(.success([TestResources.findPlacesTest]))
            findPlacesGotCalled = true
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
            findPlacesGotCalled = false
        }
    }

    func placeIDToLocation(placeID: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        if !placeID.isEmpty {
            completion(.success(CLLocationCoordinate2D()))
            placeIdToLocationGotCalled = true
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
            placeIdToLocationGotCalled = false
        }
    }

    func getDirections(origin: Coordinate, destination: Coordinate, completion: @escaping (Result<GDirectionsResponse, Error>) -> Void) {
    }
}
