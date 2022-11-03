//
//  UserTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 3/11/22.
//

import XCTest
@testable import RoutesApp_ios

class UserTests: XCTestCase {
    var userListViewModel = UserListViewModel()
    var userManager = MockUserManager()
    override func setUpWithError() throws {
        userListViewModel.userManager = userManager
    }

    func testGetUsersFromFirestore() {
        userListViewModel.getUsers()
        XCTAssert(userListViewModel.userList.count == 3)
    }

    func testToogleRole() {
        userListViewModel.toggleUserRole(for: TestResources.testUserFirebase2)
        XCTAssert((userListViewModel.userManager as? MockUserManager ?? MockUserManager()).toogleUserRoleGotCalled == true)
    }

    func testFilterUsersByName() {
        userListViewModel.getUsers()
        userListViewModel.applyFilters(query: "test1")
        XCTAssert(userListViewModel.userList.count == 1)
    }

    func testFilterUsersByEmail() {
        userListViewModel.getUsers()
        userListViewModel.applyFilters(query: "email222")
        XCTAssert(userListViewModel.userList.count == 1)
    }
}
