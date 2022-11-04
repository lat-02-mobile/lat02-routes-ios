//
//  TourpointsViewController.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/27/22.
//

import UIKit
import SVProgressHUD

class TourpointsViewController: UIViewController {

    @IBOutlet weak var tourpointSearchbar: UISearchBar!
    @IBOutlet weak var tourpointTableView: UITableView!

    var viewmodel = TourpointsViewModel()

    private let currentLocale = Locale.current.languageCode
    private var isCurrentLocaleEsp = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        initViewModel()
        setIcon()
    }

    private func setUpViews() {
        isCurrentLocaleEsp = currentLocale == ConstantVariables.spanishLocale
        tourpointTableView.delegate = self
        tourpointTableView.dataSource = self
        let uiNib = UINib(nibName: TourpointTableViewCell.nibName, bundle: nil)
        tourpointTableView.register(uiNib, forCellReuseIdentifier: TourpointTableViewCell.identifier)
        tourpointSearchbar.delegate = self
        tourpointSearchbar.backgroundImage = UIImage()
        tourpointSearchbar.searchTextField.backgroundColor = .white
        tourpointSearchbar.placeholder = String.localizeString(localizedString: StringResources.search)
    }

    private func setIcon() {
        let filterIcon = UIImage(named: ConstantVariables.filterIcon)?.withRenderingMode(.alwaysOriginal)
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(showFilterPopUp))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc func showFilterPopUp() {
        let viewControllerToPresent = TourPointFilterViewController(viewModel: viewmodel)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true)
    }

    private func initViewModel() {
        SVProgressHUD.show()
        viewmodel.onFinish = {
            SVProgressHUD.dismiss()
            self.tourpointTableView.reloadData()
        }
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
        viewmodel.getTourpoints()
    }
}

// MARK: Table view extension
extension TourpointsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.pointsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TourpointTableViewCell.identifier, for: indexPath)
                as? TourpointTableViewCell else { return UITableViewCell()}
        let point = viewmodel.getPointAt(index: indexPath.row)
        cell.updateCellModel(tourpoint: point, isCurrenLocaleEsp: isCurrentLocaleEsp)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let point = viewmodel.getPointAt(index: indexPath.row)
        let vc = TourpointDetailViewController(tourpoint: point)
        present(vc, animated: true)
    }
}

// MARK: Search Bar extension
extension TourpointsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewmodel.applyFilters(query: text, selectedCat: viewmodel.categoryAux)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewmodel.applyFilters(query: "", selectedCat: viewmodel.categoryAux)
    }
}
