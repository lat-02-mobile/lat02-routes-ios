//
//  UserListViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/11/22.
//

import UIKit
import SVProgressHUD

class UserListViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var usersSearchBar: UISearchBar!
    @IBOutlet weak var actionUserButton: FabButton!

    var targetUser: UserFirebase?

    let viewmodel = UserListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initViewModel()
    }

    @IBAction func toggleUserStatus(_ sender: Any) {
        guard let targetUser = self.targetUser else { return }
        ConfirmAlert(title: String.localizeString(localizedString: targetUser.type == UserType.ADMIN.rawValue ?
                                                  StringResources.adminUserRevokeTitle : StringResources.adminUserPromotionTitle),
                     message: String.localizeString(localizedString: targetUser.type == UserType.ADMIN.rawValue ?
                                                    StringResources.adminUserRevokeMessage : StringResources.adminUserPromotionMessage),
                     preferredStyle: .alert).showAlert(target: self) { () in
            self.viewmodel.toggleUserRole(for: targetUser)
            self.actionUserButton.isHidden = true
        }
    }

    func setupViews() {
        actionUserButton.isHidden = true
        usersSearchBar.backgroundImage = UIImage()
        usersSearchBar.searchTextField.backgroundColor = .white
        usersSearchBar.placeholder = String.localizeString(localizedString: StringResources.adminUserSearch)
        usersSearchBar.delegate = self
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(UINib.init(nibName: UserTableViewCell.nibName,
                                           bundle: nil), forCellReuseIdentifier: UserTableViewCell.nibName)
    }

    func initViewModel() {
        viewmodel.onFinish = { [weak self] in
            SVProgressHUD.dismiss()
            self?.usersTableView.reloadData()
        }
        viewmodel.onError = { error in
            ErrorAlert.shared.showAlert(title: String.localizeString(localizedString: StringResources.adminLinesSomethingWrong),
                                        message: error,
                                        target: self)
        }
        viewmodel.getUsers()
        SVProgressHUD.show()
    }
}

// Table View
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.nibName)
            as? UserTableViewCell ?? UserTableViewCell()
        let user = viewmodel.userList[indexPath.row]
        cell.setData(user: user)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionUserButton.isHidden = false
        targetUser = viewmodel.userList[indexPath.row]
        if viewmodel.userList[indexPath.row].type == 0 {
            actionUserButton.setImage(UIImage(named: ConstantVariables.promoteIcon)?.withRenderingMode(.alwaysTemplate), for: .normal)
            actionUserButton.tintColor = UIColor(named: ConstantVariables.primaryColor)
        } else {
            actionUserButton.setImage(UIImage(named: ConstantVariables.revokeIcon)?.withRenderingMode(.alwaysTemplate), for: .normal)
            actionUserButton.tintColor = .red
        }
    }
}

// Search bar
extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewmodel.applyFilters(query: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewmodel.applyFilters(query: "")
    }
}
