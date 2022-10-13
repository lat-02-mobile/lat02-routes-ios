//
//  FavoritesListViewController.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/10/22.
//

import UIKit
import SVProgressHUD

class FavoritesListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoritesList: UITableView!

    var viewmodel = FavoritesListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        initViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewmodel.getFavorites()
    }

    private func setUpViews() {
        favoritesList.delegate = self
        favoritesList.dataSource = self
        let uiNib = UINib(nibName: FavoriteTableViewCell.nibName, bundle: nil)
        favoritesList.register(uiNib, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = String.localizeString(localizedString: StringResources.search)
        SVProgressHUD.show()
    }

    private func initViewModel() {
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.favoritesList.reloadData()
        }
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }
    private func showAlert(favorite: FavoriteDest, index: Int, isForEdit: Bool) {
        let title = String.localizeString(localizedString: isForEdit ? ConstantVariables.editFavAlertTitle : ConstantVariables.deleteFavAlertTitle)
        let message = ""
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let actionTitle = String.localizeString(localizedString: isForEdit ? ConstantVariables.save : ConstantVariables.delete)
        alert.addAction(UIAlertAction(title: actionTitle, style: isForEdit ? .default : .destructive) { _ in
            self.favoritesList.reloadData()
        })

        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: ConstantVariables.cancel), style: .cancel))

        present(alert, animated: true, completion: nil)
    }

    private func removeFromFavoritesDialog(favorite: FavoriteDest) {
        let alert = UIAlertController(
            title: (String.localizeString(localizedString: ConstantVariables.deleteFavAlertTitle)),
            message: "\(String.localizeString(localizedString: ConstantVariables.removeAlerMessage)) (\(favorite.name ?? ""))",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: ConstantVariables.delete), style: .destructive, handler: { _ in
            self.viewmodel.removeFavorite(favId: favorite.id)
        }))
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: ConstantVariables.cancel), style: .cancel))
        present(alert, animated: true)
    }

    private func showUpdateFavoriteDialog(favorite: FavoriteDest) {
        let alert = UIAlertController(
            title: String.localizeString(localizedString: ConstantVariables.saveDestAlertTitle),
            message: String.localizeString(localizedString: ConstantVariables.updateAlertMessage),
            preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.placeholder = String.localizeString(localizedString: ConstantVariables.favDestPlaceholder)
            textField.text = favorite.name
        }
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: ConstantVariables.save), style: .default) { _ in
            if let textField = alert.textFields?.first, let favName = textField.text {
                self.viewmodel.updateFavorite(favorite: favorite, newName: favName)
            }
        })
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: ConstantVariables.cancel), style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: Table view extension
extension FavoritesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.pointsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath)
                as? FavoriteTableViewCell else { return UITableViewCell()}
        let fav = viewmodel.getFavoriteAt(index: indexPath.row)
        cell.updateCellModel(favorite: fav)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fav = viewmodel.getFavoriteAt(index: indexPath.row)
        let editAction = UIContextualAction(style: .normal, title: String.localizeString(localizedString: ConstantVariables.edit)) {_, _, _ in
            self.showUpdateFavoriteDialog(favorite: fav)
        }
        let deleteAction = UIContextualAction(style: .destructive, title:
                                                String.localizeString(localizedString: ConstantVariables.delete)) { _, _, _ in
            self.removeFromFavoritesDialog(favorite: fav)
        }
        let actions = [
            deleteAction,
            editAction
        ]
        return UISwipeActionsConfiguration(actions: actions)
    }
}
